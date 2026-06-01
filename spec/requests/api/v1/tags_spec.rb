require "swagger_helper"

TAG_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    name: { type: :string },
    slug: { type: :string }
  },
  required: %w[id name slug]
}.freeze

RSpec.describe "api/v1/tags", type: :request do
  path "/api/v1/tags" do
    get("List tags") do
      tags "Tags"
      produces "application/json"

      response(200, "ok") do
        schema type: :object,
               properties: {
                 tags: { type: :array, items: TAG_SCHEMA }
               },
               required: %w[tags]

        before { create(:tag, name: "open-source", slug: "open-source") }

        run_test! do |response|
          names = JSON.parse(response.body)["tags"].map { |t| t["name"] }
          expect(names).to include("open-source")
        end
      end
    end

    post("Create tag") do
      tags "Tags"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: { tag: TAG_SCHEMA },
        required: %w[tag]
      }

      response(201, "created") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:tag) { { tag: attributes_for(:tag) } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        schema type: :object, properties: { tag: TAG_SCHEMA }, required: %w[tag]
        run_test!
      end

      response(401, "unauthenticated") do
        let(:tag) { { tag: attributes_for(:tag) } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:tag) { { tag: attributes_for(:tag, name: "") } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end
  end

  path "/api/v1/tags/{id}" do
    parameter name: :id, in: :path, type: :integer

    patch("Update tag") do
      tags "Tags"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { tag: TAG_SCHEMA },
        required: %w[tag]
      }

      response(200, "updated") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:tag_record) { create(:tag) }
        let(:id) { tag_record.id }
        let(:body) { { tag: { name: "updated-tag" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:tag_record) { create(:tag) }
        let(:id) { tag_record.id }
        let(:body) { { tag: { name: "updated-tag" } } }
        run_test!
      end

      response(404, "not found") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:id) { 0 }
        let(:body) { { tag: { name: "updated-tag" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end

    delete("Destroy tag") do
      tags "Tags"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(204, "destroyed") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:tag_record) { create(:tag) }
        let(:id) { tag_record.id }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:tag_record) { create(:tag) }
        let(:id) { tag_record.id }
        run_test!
      end
    end
  end
end
