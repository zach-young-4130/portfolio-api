module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate!, only: %i[create]

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          render_success(
            user: UserBlueprint.render_as_hash(user),
            token: issue_token(user)
          )
        else
          head :unauthorized
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
