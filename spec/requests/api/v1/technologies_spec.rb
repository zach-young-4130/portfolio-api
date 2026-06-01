require "swagger_helper"

TECHNOLOGY_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    name: { type: :string },
    slug: { type: :string },
    category: { type: :string, nullable: true }
  },
  required: %w[id name slug]
}.freeze

RSpec.describe "api/v1/technologies", type: :request do
  path "/api/v1/technologies" do
    get("List technologies") do
      tags "Technologies"
      produces "application/json"

      response(200, "ok") do
        schema type: :object,
               properties: {
                 technologies: { type: :array, items: TECHNOLOGY_SCHEMA }
               },
               required: %w[technologies]

        before { create(:technology, name: "Ruby", slug: "ruby", category: "language") }

        run_test! do |response|
          names = JSON.parse(response.body)["technologies"].map { |t| t["name"] }
          expect(names).to include("Ruby")
        end
      end
    end

    post("Create technology") do
      tags "Technologies"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :technology, in: :body, schema: {
        type: :object,
        properties: { technology: TECHNOLOGY_SCHEMA },
        required: %w[technology]
      }

      response(201, "created") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:technology) { { technology: attributes_for(:technology) } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        schema type: :object, properties: { technology: TECHNOLOGY_SCHEMA }, required: %w[technology]
        run_test!
      end

      response(401, "unauthenticated") do
        let(:technology) { { technology: attributes_for(:technology) } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:technology) { { technology: attributes_for(:technology, name: "") } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end
  end

  path "/api/v1/technologies/{id}" do
    parameter name: :id, in: :path, type: :integer

    patch("Update technology") do
      tags "Technologies"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { technology: TECHNOLOGY_SCHEMA },
        required: %w[technology]
      }

      response(200, "updated") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:tech_record) { create(:technology) }
        let(:id) { tech_record.id }
        let(:body) { { technology: { name: "Updated" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:tech_record) { create(:technology) }
        let(:id) { tech_record.id }
        let(:body) { { technology: { name: "Updated" } } }
        run_test!
      end

      response(404, "not found") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:id) { 0 }
        let(:body) { { technology: { name: "Updated" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end

    delete("Destroy technology") do
      tags "Technologies"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(204, "destroyed") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:tech_record) { create(:technology) }
        let(:id) { tech_record.id }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:tech_record) { create(:technology) }
        let(:id) { tech_record.id }
        run_test!
      end
    end
  end
end
