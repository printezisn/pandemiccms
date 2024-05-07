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

ActiveRecord::Schema[7.1].define(version: 2024_05_05_112652) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_user_roles", force: :cascade do |t|
    t.integer "admin_user_id", null: false
    t.integer "role", limit: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_admin_user_roles_on_admin_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.integer "client_id", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at", precision: nil
    t.datetime "password_changed_at", precision: nil
    t.string "unique_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.text "description"
    t.integer "status", limit: 1, default: 0
    t.index ["client_id", "email"], name: "index_admin_users_on_client_id_and_email"
    t.index ["client_id", "username"], name: "index_admin_users_on_client_id_and_username", unique: true
    t.index ["client_id"], name: "index_admin_users_on_client_id"
    t.index ["confirmation_token"], name: "index_admin_users_on_confirmation_token", unique: true
    t.index ["password_changed_at"], name: "index_admin_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "name", null: false
    t.string "slug"
    t.text "description"
    t.string "template"
    t.integer "posts_count", default: 0, null: false
    t.integer "parent_id"
    t.text "hierarchy_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "children_count", default: 0
    t.integer "visibility", limit: 1, default: 0, null: false
    t.text "body"
    t.index ["client_id", "name"], name: "index_categories_on_client_id_and_name", unique: true
    t.index ["client_id", "posts_count"], name: "index_categories_on_client_id_and_posts_count"
    t.index ["client_id"], name: "index_categories_on_client_id"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "category_categorizables", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "categorizable_type", null: false
    t.integer "categorizable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categorizable_type", "categorizable_id"], name: "index_category_categorizables_on_categorizable"
    t.index ["category_id", "categorizable_id", "categorizable_type"], name: "index_category_categorizable_on_category_and_categorizable", unique: true
    t.index ["category_id"], name: "index_category_categorizables_on_category_id"
  end

  create_table "client_domains", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "domain", null: false
    t.integer "port", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_domains_on_client_id"
    t.index ["domain", "port"], name: "index_client_domains_on_domain_and_port", unique: true
  end

  create_table "client_languages", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "language_id", null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: false, null: false
    t.index ["client_id", "language_id"], name: "index_client_languages_on_client_id_and_language_id", unique: true
    t.index ["client_id"], name: "index_client_languages_on_client_id"
    t.index ["language_id"], name: "index_client_languages_on_language_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "time_zone", null: false
    t.string "template", null: false
    t.text "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.boolean "cache_enabled", default: false, null: false
    t.integer "cache_duration"
  end

  create_table "email_templates", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "type", null: false
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "type"], name: "index_email_templates_on_client_id_and_type"
    t.index ["client_id"], name: "index_email_templates_on_client_id"
  end

  create_table "indexed_entities", force: :cascade do |t|
    t.string "indexable_type", null: false
    t.integer "indexable_id", null: false
    t.string "locale", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id", null: false
    t.index ["client_id", "locale", "indexable_type"], name: "index_indexed_entities_on_indexable_client_locale"
    t.index ["client_id"], name: "index_indexed_entities_on_client_id"
    t.index ["indexable_id", "indexable_type", "locale"], name: "index_indexed_entities_on_indexable_and_locale", unique: true
    t.index ["indexable_type", "indexable_id"], name: "index_indexed_entities_on_indexable"
  end

  create_table "languages", force: :cascade do |t|
    t.string "locale", null: false
    t.string "name", null: false
    t.string "flag", limit: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transliterations"
    t.index ["locale"], name: "index_languages_on_locale", unique: true
  end

  create_table "media", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_media_on_client_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sort_order", default: 1, null: false
    t.text "external_url"
    t.integer "menu_id", null: false
    t.string "linkable_type"
    t.integer "linkable_id"
    t.integer "parent_id"
    t.text "hierarchy_path"
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "css_class"
    t.boolean "open_in_new_window", default: false, null: false
    t.index ["linkable_type", "linkable_id"], name: "index_menu_items_on_linkable"
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
    t.index ["parent_id"], name: "index_menu_items_on_parent_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.integer "client_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "name"], name: "index_menus_on_client_id_and_name", unique: true
    t.index ["client_id"], name: "index_menus_on_client_id"
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.string "password_salt"
    t.datetime "created_at", precision: nil
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "pages", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "description"
    t.text "body"
    t.string "template"
    t.integer "status", limit: 1, default: 0, null: false
    t.integer "visibility", limit: 1, default: 0, null: false
    t.datetime "published_at", precision: nil
    t.integer "author_id", null: false
    t.integer "parent_id"
    t.text "hierarchy_path"
    t.integer "children_count", default: 0
    t.index ["author_id"], name: "index_pages_on_author_id"
    t.index ["client_id", "name"], name: "index_pages_on_client_id_and_name", unique: true
    t.index ["client_id", "status"], name: "index_pages_on_client_id_and_status"
    t.index ["client_id", "template"], name: "index_pages_on_client_id_and_template"
    t.index ["client_id"], name: "index_pages_on_client_id"
    t.index ["parent_id"], name: "index_pages_on_parent_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "description"
    t.text "body"
    t.string "template"
    t.integer "status", limit: 1, default: 0, null: false
    t.integer "visibility", limit: 1, default: 0, null: false
    t.datetime "published_at", precision: nil
    t.integer "author_id", null: false
    t.datetime "indexed_at", precision: nil
    t.string "index_version"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["client_id", "name"], name: "index_posts_on_client_id_and_name", unique: true
    t.index ["client_id", "status"], name: "index_posts_on_client_id_and_status"
    t.index ["client_id", "template"], name: "index_posts_on_client_id_and_template"
    t.index ["client_id"], name: "index_posts_on_client_id"
    t.index ["indexed_at"], name: "index_posts_on_indexed_at"
  end

  create_table "redirects", force: :cascade do |t|
    t.integer "client_id", null: false
    t.text "from"
    t.text "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_redirects_on_client_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.integer "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.integer "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.integer "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.integer "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.integer "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.integer "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "tag_taggables", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "taggable_type", null: false
    t.integer "taggable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "taggable_id", "taggable_type"], name: "index_tag_taggables_on_tag_id_and_taggable_id_and_taggable_type", unique: true
    t.index ["tag_id"], name: "index_tag_taggables_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_tag_taggables_on_taggable"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "name", null: false
    t.string "slug"
    t.text "description"
    t.string "template"
    t.integer "posts_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visibility", limit: 1, default: 0, null: false
    t.text "body"
    t.index ["client_id", "name"], name: "index_tags_on_client_id_and_name", unique: true
    t.index ["client_id", "posts_count"], name: "index_tags_on_client_id_and_posts_count"
    t.index ["client_id"], name: "index_tags_on_client_id"
  end

  create_table "translations", force: :cascade do |t|
    t.string "translatable_type", null: false
    t.integer "translatable_id", null: false
    t.string "locale", null: false
    t.text "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "locale"], name: "index_translations_on_translatable_and_locale", unique: true
    t.index ["translatable_type", "translatable_id"], name: "index_translations_on_translatable"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_user_roles", "admin_users"
  add_foreign_key "admin_users", "clients"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "categories", "clients"
  add_foreign_key "category_categorizables", "categories"
  add_foreign_key "client_domains", "clients"
  add_foreign_key "client_languages", "clients"
  add_foreign_key "client_languages", "languages"
  add_foreign_key "email_templates", "clients"
  add_foreign_key "indexed_entities", "clients"
  add_foreign_key "media", "clients"
  add_foreign_key "menu_items", "menu_items", column: "parent_id"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menus", "clients"
  add_foreign_key "pages", "admin_users", column: "author_id"
  add_foreign_key "pages", "clients"
  add_foreign_key "pages", "pages", column: "parent_id"
  add_foreign_key "posts", "admin_users", column: "author_id"
  add_foreign_key "posts", "clients"
  add_foreign_key "redirects", "clients"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "tag_taggables", "tags"
  add_foreign_key "tags", "clients"
end
