module Api
  module V1
    class BaseController < ApplicationController
      include Authentication

      before_action :authenticate!

      private

      # Public callers see only published records; an authenticated admin sees
      # every record so they can manage drafts.
      def visible_scope_for(model_class)
        current_user&.admin? ? model_class.order(:position) : model_class.published
      end

      # 403 if the caller isn't an admin. Mount via before_action on any
      # endpoint that writes admin content.
      def authorize_admin!
        return if current_user&.admin?
        render_error("Forbidden", status: :forbidden)
      end

      # ---- Response helpers ---------------------------------------------------
      #
      # Every endpoint returns either render_success or render_error. Payloads
      # passed to render_success should already be Blueprinter hashes — these
      # helpers only own the envelope (status + json wrapper), not serialization.

      # find_resource_or_404(Project) — finds by params[:id], renders 404 and
      # returns nil if missing. Controllers call `return` on nil to halt:
      #   project = find_resource_or_404(Project) or return
      def find_resource_or_404(model_class, id: params[:id])
        model_class.find_by(id: id).tap do |record|
          render_error("#{model_class.name} not found", status: :not_found) unless record
        end
      end

      # render_success(project: blueprint_hash)                  → 200
      # render_success(project: blueprint_hash, status: :created) → 201
      def render_success(status: :ok, **payload)
        render json: payload, status: status
      end

      # Accepts: an ActiveRecord record (uses its .errors), a String, a Symbol,
      # an Array of strings, or any object responding to #to_s. Always emits
      # { errors: [...] } so the frontend can type-narrow on a single shape.
      # Pass `extra:` for structured fields the frontend needs alongside the
      # message (e.g. `extra: { locked_until: iso8601 }` for lockout state).
      def render_error(error, status: :unprocessable_entity, extra: {})
        errors =
          case error
          when ActiveRecord::Base then error.errors.as_json(full_messages: true)
          when Array then error.map(&:to_s)
          else [ error.to_s ]
          end
        render json: { errors: errors, **extra }, status: status
      end
    end
  end
end
