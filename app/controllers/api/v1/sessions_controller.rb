module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate!, only: %i[create create_google]

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

      # Accepts a Google ID token from the GIS browser SDK, verifies it, and
      # finds-or-creates the user. New users always get role: "user" — admin
      # promotion is a manual operation.
      def create_google
        result = GoogleIdTokenVerifier.new.call(params[:id_token])
        return render_error("Invalid Google token", status: :unauthorized) unless result[:ok]

        payload = result[:data]
        unless payload["email_verified"]
          return render_error("Google email is not verified", status: :unauthorized)
        end

        user = find_or_create_google_user(payload)

        if user.locked?
          return render_error(
            "Account temporarily locked. Try again later.",
            status: :unauthorized,
            extra: { locked_until: user.locked_until.iso8601 }
          )
        end

        user.reset_failed_attempts!
        render_success(
          user: UserBlueprint.render_as_hash(user),
          token: issue_token(user)
        )
      end

      def destroy
        # Stateless JWT: client just discards the token. We respond 204 so
        # the frontend's logout flow stays a single network round-trip.
        head :no_content
      end

      def show
        render_success(user: UserBlueprint.render_as_hash(current_user))
      end

      private

      # First tries to match an existing Google-linked user by sub. If none,
      # falls back to email — letting a password admin link their Google
      # account on first sign-in. Otherwise creates a fresh public user.
      def find_or_create_google_user(payload)
        user = User.find_by(google_uid: payload["sub"])
        return user if user

        user = User.find_by(email: payload["email"])
        if user
          user.update!(
            google_uid: payload["sub"],
            name: user.name.presence || payload["name"],
            avatar_url: user.avatar_url.presence || payload["picture"]
          )
          return user
        end

        User.create!(
          email: payload["email"],
          google_uid: payload["sub"],
          name: payload["name"],
          avatar_url: payload["picture"],
          role: "user"
        )
      end
    end
  end
end
