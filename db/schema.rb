# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_24_183145) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "fanza_actresses", force: :cascade do |t|
    t.integer "id_fanza"
    t.string "name"
    t.jsonb "raw_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_fanza"], name: "index_fanza_actresses_on_id_fanza", unique: true
  end

  create_table "fanza_items", force: :cascade do |t|
    t.string "content_id"
    t.jsonb "raw_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "normalized_id"
    t.datetime "date"
    t.string "floor_code"
    t.index ["floor_code"], name: "index_fanza_items_on_floor_code"
    t.index ["normalized_id", "content_id"], name: "index_fanza_items_on_normalized_id_and_content_id", opclass: :gin_trgm_ops, using: :gin
    t.index ["normalized_id"], name: "index_fanza_items_on_normalized_id", opclass: :gin_trgm_ops, using: :gin
    t.index ["raw_json"], name: "index_fanza_items_on_raw_json", opclass: :jsonb_path_ops, using: :gin
  end

  create_table "javlibrary_items", force: :cascade do |t|
    t.string "normalized_id"
    t.bigint "javlibrary_page_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["javlibrary_page_id"], name: "index_javlibrary_items_on_javlibrary_page_id"
  end

  create_table "javlibrary_pages", force: :cascade do |t|
    t.string "url"
    t.text "raw_html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "api_token", limit: 128, null: false
    t.index ["api_token"], name: "index_users_on_api_token"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "javlibrary_items", "javlibrary_pages"
end
