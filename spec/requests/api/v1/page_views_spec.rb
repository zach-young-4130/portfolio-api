require "swagger_helper"

PAGE_VIEW_SCHEMA = {
  type: :object,
  properties: {
    id:         { type: :integer },
    path:       { type: :string },
    city:       { type: :string, nullable: true },
    region:     { type: :string, nullable: true },
    country:    { type: :string, nullable: true },
    created_at: { type: :string }
  },
  required: %w[id path created_at]
}.freeze

RSpec.describe "api/v1/page_views", type: :request do
  path "/api/v1/page_views" do
    post("Record a page view") do
      tags "Analytics"
      consumes "application/json"
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          page_view: {
            type: :object,
            properties: {
              path:     { type: :string },
              referrer: { type: :string, nullable: true }
            },
            required: %w[path]
          }
        },
        required: %w[page_view]
      }

      response(204, "recorded") do
        let(:body) { { page_view: { path: "/projects" } } }

        before do
          allow(Geocoder).to receive(:search).and_return([])
        end

        run_test!
      end

      response(204, "ignored (bot user agent)") do
        let(:body) { { page_view: { path: "/projects" } } }

        before do
          allow_any_instance_of(ActionDispatch::Request)
            .to receive(:user_agent).and_return("Googlebot/2.1")
        end

        run_test! do
          expect(PageView.count).to eq(0)
        end
      end
    end
  end

  path "/api/v1/page_views/stats" do
    get("Get visitor stats (admin only)") do
      tags "Analytics"
      produces "application/json"
      security [ { bearerAuth: [] } ]
      parameter name: :Authorization, in: :header, type: :string, required: false

      response(200, "ok") do
        schema type: :object,
               properties: {
                 total:      { type: :integer },
                 by_country: { type: :object },
                 by_city:    { type: :object },
                 recent:     { type: :array, items: PAGE_VIEW_SCHEMA }
               },
               required: %w[total by_country by_city recent]

        before do
          create_list(:page_view, 3)
          login_as(create(:user, :admin, password: "password1234"))
        end
        let(:Authorization) { @auth_headers["Authorization"] }

        run_test!
      end

      response(401, "unauthenticated") { run_test! }
    end
  end
end
