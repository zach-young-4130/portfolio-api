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

ActiveRecord::Schema[8.0].define(version: 2026_05_18_120000) do
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
    t.index ["position"], name: "index_projects_on_position"
    t.index ["published"], name: "index_projects_on_published"
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
end
