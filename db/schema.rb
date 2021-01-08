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

ActiveRecord::Schema.define(version: 2021_01_08_131759) do

  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_user_roles", charset: "utf8", force: :cascade do |t|
    t.bigint "admin_user_id", null: false
    t.integer "role", limit: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_admin_user_roles_on_admin_user_id"
  end

  create_table "admin_users", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.bigint "client_id", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "password_changed_at"
    t.string "unique_session_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id", "email"], name: "index_admin_users_on_client_id_and_email"
    t.index ["client_id", "username"], name: "index_admin_users_on_client_id_and_username", unique: true
    t.index ["client_id"], name: "index_admin_users_on_client_id"
    t.index ["confirmation_token"], name: "index_admin_users_on_confirmation_token", unique: true
    t.index ["password_changed_at"], name: "index_admin_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "client_domains", charset: "utf8", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "domain", null: false
    t.integer "port", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_client_domains_on_client_id"
    t.index ["domain", "port"], name: "index_client_domains_on_domain_and_port", unique: true
  end

  create_table "client_languages", charset: "utf8", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "language_id", null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id", "language_id"], name: "index_client_languages_on_client_id_and_language_id", unique: true
    t.index ["client_id"], name: "index_client_languages_on_client_id"
    t.index ["language_id"], name: "index_client_languages_on_language_id"
  end

  create_table "clients", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "time_zone", null: false
    t.string "template", null: false
    t.text "settings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "show_search_page", default: true, null: false
    t.boolean "show_tag_page", default: true, null: false
    t.boolean "show_category_page", default: true, null: false
  end

  create_table "languages", charset: "utf8", force: :cascade do |t|
    t.string "locale", null: false
    t.string "name", null: false
    t.string "flag", limit: 10, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "transliterations"
    t.index ["locale"], name: "index_languages_on_locale", unique: true
  end

  create_table "media", charset: "utf8", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_media_on_client_id"
  end

  create_table "old_passwords", charset: "utf8", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.string "password_salt"
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "posts", charset: "utf8", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_posts_on_client_id"
  end

  create_table "tag_taggables", charset: "utf8", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "taggable_type", null: false
    t.bigint "taggable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id", "taggable_id", "taggable_type"], name: "index_tag_taggables_on_tag_id_and_taggable_id_and_taggable_type", unique: true
    t.index ["tag_id"], name: "index_tag_taggables_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_tag_taggables_on_taggable"
  end

  create_table "tags", charset: "utf8", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name", null: false
    t.string "slug"
    t.text "description"
    t.string "template"
    t.integer "posts_count", default: 0, null: false
    t.integer "pages_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id", "name"], name: "index_tags_on_client_id_and_name", unique: true
    t.index ["client_id", "posts_count"], name: "index_tags_on_client_id_and_posts_count"
    t.index ["client_id"], name: "index_tags_on_client_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_user_roles", "admin_users"
  add_foreign_key "admin_users", "clients"
  add_foreign_key "client_domains", "clients"
  add_foreign_key "client_languages", "clients"
  add_foreign_key "client_languages", "languages"
  add_foreign_key "media", "clients"
  add_foreign_key "posts", "clients"
  add_foreign_key "tag_taggables", "tags"
  add_foreign_key "tags", "clients"
end
