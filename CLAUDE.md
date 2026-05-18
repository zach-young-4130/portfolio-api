# portfolio-api — project guidelines

Rails 8 API-only application. Paired with the Angular frontend at `../portfolio-frontend`.

This file extends — does not replace — `~/.claude/CLAUDE.md` (global standards: simplicity, reuse rules, surgical changes, goal-driven execution, env/git safety) and the `ruby-on-rails` skill (general Rails 8 patterns). Read those first; rules below are project-specific additions or overrides.

## 1. Every endpoint = request spec + swagger doc, in the same change

This is the load-bearing rule of this project. **Never ship an endpoint without both.**

When adding or modifying an endpoint:

1. Write/update the request spec at `spec/requests/api/v<n>/<resource>_spec.rb` using the **rswag DSL** (`path`, `consumes`, `produces`, `parameter`, `response`, `schema`, `run_test!`). Plain `describe ... it ...` request specs are not enough — they don't generate docs.
2. Document at minimum:
   - The success status (200/201/204) with response `schema`.
   - 401 if the endpoint requires auth.
   - 422 if the endpoint accepts user input that can fail validation.
   - 404 if the endpoint looks up a record by id.
3. Regenerate the OpenAPI yaml: `bundle exec rake rswag:specs:swaggerize`. The generated `swagger/v1/swagger.yaml` is the contract with the frontend. Commit it in the same change as the spec.

Do not hand-write `swagger/v1/swagger.yaml`. Do not "stub now, document later" — the doc IS the spec, and the spec proves the doc.

## 2. API conventions

- **Versioned namespace**: all endpoints live under `/api/v<n>/...`. Controllers under `app/controllers/api/v<n>/`. Bump the version on breaking changes; never silently change a published shape.
- **BaseController**: every versioned controller inherits from `Api::V<n>::BaseController`, which includes the `Authentication` concern and runs `before_action :authenticate!`. Public endpoints opt out with `skip_before_action :authenticate!`.
- **Strong params**: use `params.expect(post: %i[title body])` (Rails 8). Do not use the legacy `params.require(:post).permit(...)`.
- **Status codes**: 200 reads, 201 creates that return a resource, 204 destroys/logouts, 401 missing auth, 403 forbidden, 404 not found, 422 validation failure. Do not return 200 with `{ ok: false }` — use the right status.
- **Validation error body**: `render json: { errors: record.errors.as_json(full_messages: true) }, status: :unprocessable_entity`. Be consistent — the frontend type-narrows on this shape.
- **No `respond_to` blocks** unless an endpoint genuinely serves multiple formats. API endpoints serve JSON; just `render json:` (or use Jbuilder when nesting gets noisy).

## 3. Authentication

- Single admin user. Auth is **stateless JWT** — no sessions, no cookies. Admin creds are seeded from Rails encrypted credentials (`admin: { email:, password: }` in `config/credentials.yml.enc`). Edit with `bin/rails credentials:edit`. Decryption requires `config/master.key` (gitignored) or `RAILS_MASTER_KEY` env var.
- `current_user`, `authenticate!`, `issue_token(user)` live in `app/controllers/concerns/authentication.rb`. Reuse them — do not reimplement JWT decoding in controllers.
- Token encoding lives in `app/services/json_web_token.rb`. HS256 signed with `Rails.application.secret_key_base`, 7-day expiry by default. Claims: `sub` (user id), `exp`, `iat`.
- Login flow: `POST /api/v1/session` with email/password returns `{ user, token }`. Frontend stores the token (localStorage) and sends `Authorization: Bearer <token>` on every authenticated request.
- Logout flow: `DELETE /api/v1/session` is a no-op on the server (the JWT is stateless). The frontend discards the token locally. No server-side blocklist — token remains valid until `exp`. For a single admin this is acceptable; if the threat model changes, add a `jti` claim + Redis blocklist.
- **No CSRF middleware.** With JWT in the `Authorization` header (not a cookie), CSRF is structurally impossible — browsers do not auto-attach the header on cross-site requests the way they do cookies. Do not add `protect_from_forgery`.
- **CORS no longer requires `credentials: true`.** Without cookies in the auth flow, the browser never needs to send credentials cross-origin.

## 4. Models & migrations

- `normalizes :field, with: ->(v) { ... }` for whitespace/case normalization (Rails 7.1+). Don't sprinkle `before_validation` callbacks for this.
- Validate at the model layer, AND add DB constraints (`null: false`, unique indexes, foreign keys) as defense in depth.
- Migrations use `def change` with reversible methods. Use `def up` / `def down` only when truly irreversible (raw SQL data transforms). For partially-reversible logic, use `reversible do |dir|` inside `change`.
- Always add an index on FK columns and on any column you `find_by` or `where` on at request time.

## 5. Service objects

Extract to `app/services/<verb>_<noun>_service.rb` (e.g. `PublishPostService`) when an action involves any of:
- Multiple model writes that must succeed or fail together
- External side effects (mail, HTTP, file upload, payment)
- Logic the controller would need to repeat across actions

Service objects expose a single `#call` and return a result hash with at minimum `ok:` and either `data:` / `error:`. See the `ruby-on-rails` skill for the canonical shape.

## 6. Testing

- **RSpec + FactoryBot only.** No Minitest, no fixtures.
- Factories live at `spec/factories/<model>.rb`. Use `sequence(:field)` for any unique field.
- Request specs use the rswag DSL (rule #1). Model specs and service specs are plain RSpec.
- Run all specs: `bundle exec rspec`. Regenerate docs: `bundle exec rake rswag:specs:swaggerize`. Both should pass before declaring work done.
- Don't mock ActiveRecord. Hit the real test DB.

## 7. Frontend pairing

- CORS allows `http://localhost:4200` and `http://127.0.0.1:4200` in dev. Production frontend origin will need to be added when deploy is in scope.
- When changing the API contract (new required param, renamed field, removed endpoint, status code change), call it out explicitly — the change must land in `../portfolio-frontend` at the same time. Do not assume the reviewer will catch it.
- The OpenAPI yaml at `swagger/v1/swagger.yaml` is the inter-repo contract. If it changes, the frontend's typed client probably needs to regenerate.

## 8. Don't run install / migrate / destructive commands

(This is in the global CLAUDE.md but worth re-stating in the API context — it's where it bites most often.)

- `bundle install`, `bin/rails db:migrate`, `bin/rails db:rollback`, `bin/rails db:seed`, `bin/rails db:reset`, `bin/rails db:drop`: prompt me to run these.
- Generators (`rails g model`, `rails g migration`) are fine to run — they only create files.
- Never amend or push without being asked.
