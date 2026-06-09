require "swagger_helper"

FAQ_ITEM_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    question: { type: :string },
    answer: { type: :string },
    position: { type: :integer, nullable: true },
    published: { type: :boolean }
  },
  required: %w[id question answer published]
}.freeze

RSpec.describe "api/v1/faq_items", type: :request do
  path "/api/v1/faq_items" do
    get("List FAQ items (published only when public; all when authenticated)") do
      tags "FAQ Items"
      produces "application/json"
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "ok") do
        schema type: :object,
               properties: {
                 faq_items: { type: :array, items: FAQ_ITEM_SCHEMA }
               },
               required: %w[faq_items]

        before do
          create(:faq_item, question: "Public?", published: true)
          create(:faq_item, question: "Hidden draft?", published: false)
        end

        run_test! do |response|
          questions = JSON.parse(response.body)["faq_items"].map { |i| i["question"] }
          expect(questions).to include("Public?")
          expect(questions).not_to include("Hidden draft?")
        end
      end

      response(200, "ok (authenticated includes drafts)") do
        let(:user) { create(:user, :admin, password: "password1234") }

        before do
          create(:faq_item, question: "Public?", published: true)
          create(:faq_item, question: "Draft?", published: false)
          login_as(user)
        end
        let(:Authorization) { @auth_headers["Authorization"] }

        run_test! do |response|
          questions = JSON.parse(response.body)["faq_items"].map { |i| i["question"] }
          expect(questions).to include("Public?", "Draft?")
        end
      end
    end

    post("Create FAQ item") do
      tags "FAQ Items"
      consumes "application/json"
      produces "application/json"
      security [ { bearerAuth: [] } ]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { faq_item: FAQ_ITEM_SCHEMA },
        required: %w[faq_item]
      }

      response(201, "created") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:body) { { faq_item: attributes_for(:faq_item) } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:body) { { faq_item: attributes_for(:faq_item) } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:body) { { faq_item: attributes_for(:faq_item, question: "") } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end
  end

  path "/api/v1/faq_items/{id}" do
    parameter name: :id, in: :path, type: :integer

    patch("Update FAQ item") do
      tags "FAQ Items"
      consumes "application/json"
      produces "application/json"
      security [ { bearerAuth: [] } ]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { faq_item: FAQ_ITEM_SCHEMA },
        required: %w[faq_item]
      }

      response(200, "updated") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:item) { create(:faq_item) }
        let(:id) { item.id }
        let(:body) { { faq_item: { question: "Updated?" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:item) { create(:faq_item) }
        let(:id) { item.id }
        let(:body) { { faq_item: { question: "Updated?" } } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:item) { create(:faq_item) }
        let(:id) { item.id }
        let(:body) { { faq_item: { question: "" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end

    delete("Destroy FAQ item") do
      tags "FAQ Items"
      security [ { bearerAuth: [] } ]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(204, "destroyed") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:item) { create(:faq_item) }
        let(:id) { item.id }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:item) { create(:faq_item) }
        let(:id) { item.id }
        run_test!
      end
    end
  end
end
