require "swagger_helper"

USER_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    email: { type: :string },
    name: { type: :string, nullable: true },
    avatar_url: { type: :string, nullable: true },
    role: { type: :string, enum: %w[user admin] }
  },
  required: %w[id email role]
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
        let(:user) { create(:user, password: "password1234") }
        let(:credentials) { { email: user.email, password: "password1234" } }

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

      response(401, "account locked after repeated failures") do
        let(:user) { create(:user, password: "password1234") }
        let(:credentials) { { email: user.email, password: "wrong-password" } }

        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } },
                 locked_until: { type: :string, format: "date-time" }
               },
               required: %w[errors locked_until]

        before do
          User::MAX_FAILED_ATTEMPTS.times { user.register_failed_attempt! }
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["locked_until"]).to be_present
          expect(body["errors"].first).to match(/locked/i)
        end
      end
    end

    delete("Logout (client discards token)") do
      tags "Sessions"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(204, "logged out") do
        let(:user) { create(:user, password: "password1234") }
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
        let(:user) { create(:user, password: "password1234") }
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

  path "/api/v1/session/google" do
    post("Login or sign up via Google Identity Services") do
      tags "Sessions"
      consumes "application/json"
      produces "application/json"
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { id_token: { type: :string } },
        required: %w[id_token]
      }

      response(200, "logged in via Google") do
        schema type: :object, properties: {
          user: USER_SCHEMA,
          token: { type: :string }
        }, required: %w[user token]

        let(:google_payload) do
          {
            "sub" => "google-uid-123",
            "email" => "new.visitor@example.com",
            "email_verified" => true,
            "name" => "New Visitor",
            "picture" => "https://example.com/avatar.jpg"
          }
        end
        let(:body) { { id_token: "stub-token" } }

        before do
          allow_any_instance_of(GoogleIdTokenVerifier)
            .to receive(:call).and_return({ ok: true, data: google_payload })
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.dig("user", "email")).to eq("new.visitor@example.com")
          expect(body.dig("user", "role")).to eq("user")
          expect(body["token"]).to be_a(String).and(be_present)
        end
      end

      response(401, "invalid Google token") do
        let(:body) { { id_token: "bad-token" } }

        before do
          allow_any_instance_of(GoogleIdTokenVerifier)
            .to receive(:call).and_return({ ok: false, error: "bad token" })
        end

        run_test!
      end
    end
  end
end
