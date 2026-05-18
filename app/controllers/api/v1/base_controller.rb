module Api
  module V1
    class BaseController < ApplicationController
      include Authentication

      before_action :authenticate!

      private

      # Public callers see only published records; an authenticated admin sees
      # every record so they can manage drafts.
      def visible_scope_for(model_class)
        current_user ? model_class.order(:position) : model_class.published
      end

      # ---- Response helpers ---------------------------------------------------

      # render_success(project: blueprint_hash)               → 200
      # render_success(project: blueprint_hash, status: :created) → 201
      def render_success(status: :ok, **payload)
        render json: payload, status: status
      end

      # 201-flavored success: render_created(project: blueprint_hash)
      def render_created(**payload)
        render_success(status: :created, **payload)
      end

      # 422 with the AR errors hash the frontend type-narrows on.
      def render_validation_errors(record)
        render json: { errors: record.errors.as_json(full_messages: true) },
               status: :unprocessable_entity
      end

      # 404 — the find_by-returns-nil shortcut.
      def render_not_found
        head :not_found
      end
    end
  end
end
