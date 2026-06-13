module AuthHelpers
  # Logs the user in by hitting POST /session and stashes the returned JWT
  # in @auth_headers. Subsequent requests in the same example that pass
  # `headers: auth_headers` will be authenticated.
  def login_as(user, password: "password1234")
    post "/api/v1/session",
         params: { email: user.email, password: password },
         as: :json

    token = JSON.parse(response.body).fetch("token")
    @auth_headers = { "Authorization" => "Bearer #{token}" }
  end

  def auth_headers
    @auth_headers || {}
  end

  # rswag's request factory resolves every declared header parameter by sending
  # its name to the example — including optional ones. The "unauthenticated"
  # examples intentionally omit `let(:Authorization)`, so without this default
  # rswag raises NoMethodError instead of sending the request with no token.
  # Authenticating examples override this with their own `let(:Authorization)`.
  def Authorization
    nil
  end
end
