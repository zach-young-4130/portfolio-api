# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_06_01_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "community_items", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "url"
    t.string "role"
    t.string "year"
    t.integer "position"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tech_stack"
    t.index ["position"], name: "index_community_items_on_position"
    t.index ["published"], name: "index_community_items_on_published"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "message", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_contact_messages_on_read_at"
  end

  create_table "faq_items", force: :cascade do |t|
    t.string "question", null: false
    t.text "answer", null: false
    t.integer "position"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_faq_items_on_position"
    t.index ["published"], name: "index_faq_items_on_published"
  end

  create_table "page_views", force: :cascade do |t|
    t.string "path", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.string "referrer"
    t.string "city"
    t.string "region"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_page_views_on_city"
    t.index ["country"], name: "index_page_views_on_country"
    t.index ["created_at"], name: "index_page_views_on_created_at"
  end

  create_table "project_technologies", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "technology_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_project_technologies_on_position"
    t.index ["project_id", "technology_id"], name: "index_project_technologies_on_project_id_and_technology_id", unique: true
    t.index ["project_id"], name: "index_project_technologies_on_project_id"
    t.index ["technology_id"], name: "index_project_technologies_on_technology_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title", null: false
    t.string "tagline", null: false
    t.text "description", null: false
    t.string "tech_stack", null: false
    t.string "cover_image_url"
    t.string "live_url"
    t.string "repo_url"
    t.boolean "featured", default: false, null: false
    t.integer "position"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "project_start"
    t.date "project_end"
    t.index "((((setweight(to_tsvector('simple'::regconfig, (COALESCE(title, ''::character varying))::text), 'A'::\"char\") || setweight(to_tsvector('simple'::regconfig, (COALESCE(tagline, ''::character varying))::text), 'A'::\"char\")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(tech_stack, ''::character varying))::text), 'B'::\"char\")) || setweight(to_tsvector('simple'::regconfig, COALESCE(description, ''::text)), 'C'::\"char\")))", name: "index_projects_on_fts", using: :gin
    t.index ["position"], name: "index_projects_on_position"
    t.index ["published"], name: "index_projects_on_published"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "taggable_type", null: false
    t.bigint "taggable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "taggable_type", "taggable_id"], name: "index_taggings_on_tag_id_and_taggable_type_and_taggable_id", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_technologies_on_category"
    t.index ["name"], name: "index_technologies_on_name", unique: true
    t.index ["slug"], name: "index_technologies_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_until"
    t.string "google_uid"
    t.string "name"
    t.string "avatar_url"
    t.string "role", default: "user", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_uid"], name: "index_users_on_google_uid", unique: true
    t.index ["locked_until"], name: "index_users_on_locked_until"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "project_technologies", "projects"
  add_foreign_key "project_technologies", "technologies"
  add_foreign_key "taggings", "tags"
end
