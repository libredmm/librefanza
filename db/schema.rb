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

ActiveRecord::Schema[7.1].define(version: 2024_01_08_183945) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "fanza_actresses", force: :cascade do |t|
    t.integer "fanza_id"
    t.string "name"
    t.jsonb "raw_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hidden", default: false, null: false
    t.index ["fanza_id"], name: "index_fanza_actresses_on_fanza_id", unique: true
    t.index ["name"], name: "fuzzy_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_fanza_actresses_on_name"
    t.index ["raw_json"], name: "index_fanza_actresses_on_raw_json", opclass: :jsonb_path_ops, using: :gin
  end

  create_table "fanza_items", force: :cascade do |t|
    t.string "content_id"
    t.jsonb "raw_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "normalized_id"
    t.datetime "date", precision: nil
    t.string "floor_code"
    t.string "service_code"
    t.text "description"
    t.integer "priority", default: 0, null: false
    t.index ["content_id"], name: "index_fanza_items_on_content_id"
    t.index ["date"], name: "index_fanza_items_on_date"
    t.index ["floor_code"], name: "index_fanza_items_on_floor_code"
    t.index ["normalized_id", "content_id"], name: "index_fanza_items_on_normalized_id_and_content_id", opclass: :gin_trgm_ops, using: :gin
    t.index ["normalized_id", "date"], name: "index_fanza_items_on_normalized_id_and_date"
    t.index ["normalized_id"], name: "index_fanza_items_on_normalized_id"
    t.index ["priority"], name: "index_fanza_items_on_priority"
    t.index ["raw_json"], name: "index_fanza_items_on_raw_json", opclass: :jsonb_path_ops, using: :gin
    t.index ["service_code"], name: "index_fanza_items_on_service_code"
  end

  create_table "feeds", force: :cascade do |t|
    t.string "uri"
    t.string "host"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "accessed_at", default: -> { "now()" }, null: false
    t.index ["host"], name: "index_feeds_on_host"
    t.index ["uri"], name: "index_feeds_on_uri", unique: true
  end

  create_table "javlibrary_items", force: :cascade do |t|
    t.string "normalized_id"
    t.integer "javlibrary_page_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "actress_names", array: true
    t.index ["actress_names"], name: "index_javlibrary_items_on_actress_names", using: :gin
    t.index ["javlibrary_page_id"], name: "index_javlibrary_items_on_javlibrary_page_id"
    t.index ["normalized_id"], name: "index_javlibrary_items_on_normalized_id"
  end

  create_table "javlibrary_pages", force: :cascade do |t|
    t.string "url"
    t.text "raw_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_javlibrary_pages_on_url", unique: true
  end

  create_table "mgstage_items", force: :cascade do |t|
    t.string "normalized_id"
    t.integer "mgstage_page_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "actress_names", array: true
    t.index ["actress_names"], name: "index_mgstage_items_on_actress_names", using: :gin
    t.index ["mgstage_page_id"], name: "index_mgstage_items_on_mgstage_page_id"
    t.index ["normalized_id"], name: "index_mgstage_items_on_normalized_id", unique: true
  end

  create_table "mgstage_pages", force: :cascade do |t|
    t.string "url"
    t.text "raw_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_mgstage_pages_on_url", unique: true
  end

  create_table "movies", force: :cascade do |t|
    t.string "normalized_id", null: false
    t.string "compressed_id", null: false
    t.datetime "date", precision: nil
    t.integer "actress_fanza_ids", array: true
    t.string "actress_names", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hidden", default: false, null: false
    t.string "cover_image_url"
    t.index ["actress_fanza_ids"], name: "index_movies_on_actress_fanza_ids", using: :gin
    t.index ["actress_names"], name: "index_movies_on_actress_names", using: :gin
    t.index ["compressed_id"], name: "index_movies_on_compressed_id"
    t.index ["date", "normalized_id"], name: "index_movies_on_date_and_normalized_id"
    t.index ["date"], name: "index_movies_on_date"
    t.index ["normalized_id", "compressed_id"], name: "index_movies_on_normalized_id_and_compressed_id", opclass: :gin_trgm_ops, using: :gin
    t.index ["normalized_id"], name: "index_movies_on_normalized_id", unique: true
  end

  create_table "sod_items", force: :cascade do |t|
    t.string "normalized_id"
    t.bigint "sod_page_id", null: false
    t.string "actress_names", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actress_names"], name: "index_sod_items_on_actress_names", using: :gin
    t.index ["sod_page_id"], name: "index_sod_items_on_sod_page_id"
  end

  create_table "sod_pages", force: :cascade do |t|
    t.string "url"
    t.text "raw_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_sod_pages_on_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "api_token", limit: 128, null: false
    t.boolean "is_admin", default: false, null: false
    t.index ["api_token"], name: "index_users_on_api_token"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "javlibrary_items", "javlibrary_pages"
  add_foreign_key "mgstage_items", "mgstage_pages"
  add_foreign_key "sod_items", "sod_pages"
end
