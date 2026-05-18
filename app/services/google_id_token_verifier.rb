require "google-id-token"

# Verifies a Google Identity Services ID token against Google's public keys
# and returns the decoded claims (sub, email, email_verified, name, picture).
#
# Usage:
#   result = GoogleIdTokenVerifier.new.call(params[:id_token])
#   if result[:ok]
#     payload = result[:data]      # Hash with "sub", "email", "name", "picture", "email_verified", ...
#   else
#     result[:error]               # String describing why
#   end
class GoogleIdTokenVerifier
  include ServiceResult

  def call(id_token)
    return error("Missing id_token") if id_token.blank?

    client_id = Rails.application.credentials.dig(:google, :client_id)
    return error("Google client_id not configured") if client_id.blank?

    payload = GoogleIDToken::Validator.new.check(id_token, client_id)
    success(payload)
  rescue GoogleIDToken::ValidationError => e
    error("Invalid Google token: #{e.message}")
  end
end
