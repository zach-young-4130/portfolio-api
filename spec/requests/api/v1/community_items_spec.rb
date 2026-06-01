require "swagger_helper"

COMMUNITY_ITEM_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    title: { type: :string },
    description: { type: :string },
    url: { type: :string, nullable: true },
    role: { type: :string, nullable: true },
    year: { type: :string, nullable: true },
    tech_stack: { type: :string, nullable: true },
    position: { type: :integer, nullable: true },
    published: { type: :boolean },
    tags: {
      type: :array,
      items: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          slug: { type: :string }
        },
        required: %w[id name slug]
      }
    }
  },
  required: %w[id title description published tags]
}.freeze

RSpec.describe "api/v1/community_items", type: :request do
  path "/api/v1/community_items" do
    get("List community items (published only when public; all when authenticated)") do
      tags "Community Items"
      produces "application/json"
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "ok") do
        schema type: :object,
               properties: {
                 community_items: { type: :array, items: COMMUNITY_ITEM_SCHEMA }
               },
               required: %w[community_items]

        before do
          create(:community_item, title: "Public", published: true)
          create(:community_item, title: "Hidden draft", published: false)
        end

        run_test! do |response|
          titles = JSON.parse(response.body)["community_items"].map { |i| i["title"] }
          expect(titles).to include("Public")
          expect(titles).not_to include("Hidden draft")
        end
      end

      response(200, "ok (authenticated includes drafts)") do
        let(:user) { create(:user, :admin, password: "password1234") }

        before do
          create(:community_item, title: "Public", published: true)
          create(:community_item, title: "Draft", published: false)
          login_as(user)
        end
        let(:Authorization) { @auth_headers["Authorization"] }

        run_test! do |response|
          titles = JSON.parse(response.body)["community_items"].map { |i| i["title"] }
          expect(titles).to include("Public", "Draft")
        end
      end
    end

    post("Create community item") do
      tags "Community Items"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { community_item: COMMUNITY_ITEM_SCHEMA },
        required: %w[community_item]
      }

      response(201, "created") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:tag) { create(:tag) }
        let(:body) { { community_item: attributes_for(:community_item).merge(tag_ids: [ tag.id ]) } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["community_item"]["tags"].map { |t| t["id"] }).to include(tag.id)
        end
      end

      response(401, "unauthenticated") do
        let(:body) { { community_item: attributes_for(:community_item) } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:body) { { community_item: attributes_for(:community_item, title: "") } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end
  end

  path "/api/v1/community_items/{id}" do
    parameter name: :id, in: :path, type: :integer

    patch("Update community item") do
      tags "Community Items"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { community_item: COMMUNITY_ITEM_SCHEMA },
        required: %w[community_item]
      }

      response(200, "updated") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:item) { create(:community_item) }
        let(:id) { item.id }
        let(:body) { { community_item: { title: "Updated" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:item) { create(:community_item) }
        let(:id) { item.id }
        let(:body) { { community_item: { title: "Updated" } } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:item) { create(:community_item) }
        let(:id) { item.id }
        let(:body) { { community_item: { title: "" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end

    delete("Destroy community item") do
      tags "Community Items"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(204, "destroyed") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:item) { create(:community_item) }
        let(:id) { item.id }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:item) { create(:community_item) }
        let(:id) { item.id }
        run_test!
      end
    end
  end
end
