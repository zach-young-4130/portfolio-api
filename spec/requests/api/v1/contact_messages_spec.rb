require "swagger_helper"

CONTACT_MESSAGE_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    name: { type: :string },
    email: { type: :string },
    message: { type: :string },
    read_at: { type: :string, format: "date-time", nullable: true },
    created_at: { type: :string, format: "date-time" }
  },
  required: %w[id name email message]
}.freeze

RSpec.describe "api/v1/contact_messages", type: :request do
  path "/api/v1/contact_messages" do
    post("Submit a contact message") do
      tags "Contact Messages"
      consumes "application/json"
      produces "application/json"
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          contact_message: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              message: { type: :string }
            },
            required: %w[name email message]
          }
        },
        required: %w[contact_message]
      }

      response(201, "created") do
        let(:body) { { contact_message: { name: "Jane", email: "jane@example.com", message: "Hello" } } }
        run_test!
      end

      response(422, "invalid") do
        let(:body) { { contact_message: { name: "", email: "bad", message: "" } } }
        run_test!
      end
    end

    get("List unread contact messages") do
      tags "Contact Messages"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "ok") do
        let(:user) { create(:user, password: "password123") }
        before do
          create(:contact_message)
          login_as(user)
        end
        let(:Authorization) { @auth_headers["Authorization"] }
        schema type: :object,
               properties: {
                 contact_messages: { type: :array, items: CONTACT_MESSAGE_SCHEMA }
               },
               required: %w[contact_messages]
        run_test!
      end

      response(401, "unauthenticated") do
        run_test!
      end
    end
  end

  path "/api/v1/contact_messages/{id}" do
    parameter name: :id, in: :path, type: :integer

    patch("Mark a contact message as read") do
      tags "Contact Messages"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "marked read") do
        let(:user) { create(:user, password: "password123") }
        let(:message) { create(:contact_message) }
        let(:id) { message.id }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        schema type: :object, properties: { contact_message: CONTACT_MESSAGE_SCHEMA }, required: %w[contact_message]
        run_test!
      end

      response(401, "unauthenticated") do
        let(:message) { create(:contact_message) }
        let(:id) { message.id }
        run_test!
      end
    end
  end
end
