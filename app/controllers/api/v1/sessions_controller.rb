module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate!, only: %i[create]

      def create
        existing = User.find_by(email: params[:email])

        if existing&.locked?
          return render_error(
            "Account temporarily locked. Try again later.",
            status: :unauthorized,
            extra: { locked_until: existing.locked_until.iso8601 }
          )
        end

        # authenticate_by runs bcrypt whether or not the user exists, so
        # response time can't be used to enumerate valid emails.
        user = User.authenticate_by(email: params[:email], password: params[:password])

        if user
          user.reset_failed_attempts!
          render_success(
            user: UserBlueprint.render_as_hash(user),
            token: issue_token(user)
          )
        else
          existing&.register_failed_attempt!
          render_error("Invalid credentials", status: :unauthorized)
        end
      end

      def destroy
        # Stateless JWT: client just discards the token. We respond 204 so
        # the frontend's logout flow stays a single network round-trip.
        head :no_content
      end

      def show
        render_success(user: UserBlueprint.render_as_hash(current_user))
      end
    end
  end
end
