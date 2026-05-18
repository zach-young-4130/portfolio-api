require "swagger_helper"

USER_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    email: { type: :string }
  },
  required: %w[id email]
}.freeze

RSpec.describe "api/v1/sessions", type: :request do
  path "/api/v1/session" do
    post("Login (issue JWT)") do
      tags "Sessions"
      consumes "application/json"
      produces "application/json"
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response(200, "logged in") do
        let(:user) { create(:user, password: "password123") }
        let(:credentials) { { email: user.email, password: "password123" } }

        schema type: :object, properties: {
          user: USER_SCHEMA,
          token: { type: :string }
        }, required: %w[user token]

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.dig("user", "email")).to eq(user.email)
          expect(body["token"]).to be_a(String).and(be_present)
        end
      end

      response(401, "invalid credentials") do
        let(:credentials) { { email: "nope@example.com", password: "wrong" } }
        run_test!
      end
    end

    delete("Logout (client discards token)") do
      tags "Sessions"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(204, "logged out") do
        let(:user) { create(:user, password: "password123") }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "missing or invalid token") do
        run_test!
      end
    end

    get("Current session") do
      tags "Sessions"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "authenticated") do
        let(:user) { create(:user, password: "password123") }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }

        schema type: :object, properties: { user: USER_SCHEMA }, required: %w[user]

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.dig("user", "email")).to eq(user.email)
        end
      end

      response(401, "unauthenticated") do
        run_test!
      end
    end
  end
end
