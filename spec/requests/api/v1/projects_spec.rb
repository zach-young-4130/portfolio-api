require "swagger_helper"

PROJECT_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :integer },
    title: { type: :string },
    tagline: { type: :string },
    description: { type: :string },
    tech_stack: { type: :string },
    cover_image_url: { type: :string, nullable: true },
    live_url: { type: :string, nullable: true },
    repo_url: { type: :string, nullable: true },
    featured: { type: :boolean },
    position: { type: :integer, nullable: true },
    published: { type: :boolean },
    project_start: { type: :string, format: "date", nullable: true },
    project_end: { type: :string, format: "date", nullable: true }
  },
  required: %w[id title tagline description tech_stack featured published]
}.freeze

RSpec.describe "api/v1/projects", type: :request do
  path "/api/v1/projects" do
    get("List projects (published only when public; all when authenticated)") do
      tags "Projects"
      produces "application/json"
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "ok") do
        schema type: :object,
               properties: {
                 projects: { type: :array, items: PROJECT_SCHEMA }
               },
               required: %w[projects]

        before do
          create(:project, title: "Public", published: true)
          create(:project, title: "Hidden Draft", published: false)
        end

        run_test! do |response|
          titles = JSON.parse(response.body)["projects"].map { |p| p["title"] }
          expect(titles).to include("Public")
          expect(titles).not_to include("Hidden Draft")
        end
      end

      response(200, "ok (authenticated includes drafts)") do
        let(:user) { create(:user, :admin, password: "password1234") }

        before do
          create(:project, title: "Public", published: true)
          create(:project, title: "Draft", published: false)
          login_as(user)
        end
        let(:Authorization) { @auth_headers["Authorization"] }

        run_test! do |response|
          titles = JSON.parse(response.body)["projects"].map { |p| p["title"] }
          expect(titles).to include("Public", "Draft")
        end
      end
    end

    post("Create project") do
      tags "Projects"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          project: PROJECT_SCHEMA
        },
        required: %w[project]
      }

      response(201, "created") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:project) { { project: attributes_for(:project) } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        schema type: :object, properties: { project: PROJECT_SCHEMA }, required: %w[project]
        run_test!
      end

      response(401, "unauthenticated") do
        let(:project) { { project: attributes_for(:project) } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:project) { { project: attributes_for(:project, title: "") } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end
  end

  path "/api/v1/projects/{id}" do
    parameter name: :id, in: :path, type: :integer

    get("Show project (published only when public; any when authenticated)") do
      tags "Projects"
      produces "application/json"
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "ok") do
        let(:project_record) { create(:project, published: true) }
        let(:id) { project_record.id }
        schema type: :object, properties: { project: PROJECT_SCHEMA }, required: %w[project]
        run_test!
      end

      response(404, "not found") do
        let(:id) { 0 }
        run_test!
      end

      response(404, "draft hidden from public") do
        let(:project_record) { create(:project, published: false) }
        let(:id) { project_record.id }
        run_test!
      end

      response(200, "draft visible to authenticated admin") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:project_record) { create(:project, published: false) }
        let(:id) { project_record.id }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end

    patch("Update project") do
      tags "Projects"
      consumes "application/json"
      produces "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { project: PROJECT_SCHEMA },
        required: %w[project]
      }

      response(200, "updated") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:project_record) { create(:project) }
        let(:id) { project_record.id }
        let(:body) { { project: { title: "Updated" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:project_record) { create(:project) }
        let(:id) { project_record.id }
        let(:body) { { project: { title: "Updated" } } }
        run_test!
      end

      response(422, "invalid") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:project_record) { create(:project) }
        let(:id) { project_record.id }
        let(:body) { { project: { title: "" } } }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end
    end

    delete("Destroy project") do
      tags "Projects"
      security [{ bearerAuth: [] }]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(204, "destroyed") do
        let(:user) { create(:user, :admin, password: "password1234") }
        let(:project_record) { create(:project) }
        let(:id) { project_record.id }
        before { login_as(user) }
        let(:Authorization) { @auth_headers["Authorization"] }
        run_test!
      end

      response(401, "unauthenticated") do
        let(:project_record) { create(:project) }
        let(:id) { project_record.id }
        run_test!
      end
    end
  end
end
