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
end
