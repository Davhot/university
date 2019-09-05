# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_12_14_192426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disks", force: :cascade do |t|
    t.string "name"
    t.string "filesystem"
    t.integer "size"
    t.integer "used"
    t.string "mounted_on"
    t.bigint "hot_catch_app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hot_catch_app_id"], name: "index_disks_on_hot_catch_app_id"
  end

  create_table "hot_catch_apps", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "main_hot_catch_logs", force: :cascade do |t|
    t.text "log_data", null: false
    t.integer "count_log", default: 1, null: false
    t.string "from_log", null: false
    t.string "status", null: false
    t.bigint "hot_catch_app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hot_catch_app_id"], name: "index_main_hot_catch_logs_on_hot_catch_app_id"
  end

  create_table "main_metrics", force: :cascade do |t|
    t.integer "memory_size"
    t.integer "swap_size"
    t.integer "descriptors_max"
    t.string "architecture"
    t.string "os"
    t.string "os_version"
    t.string "host_name"
    t.bigint "hot_catch_app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hot_catch_app_id"], name: "index_main_metrics_on_hot_catch_app_id"
  end

  create_table "network_steps", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.float "bytes_in", default: 0.0
    t.float "bytes_out", default: 0.0
    t.float "packets_in", default: 0.0
    t.float "packets_out", default: 0.0
    t.datetime "get_time"
    t.bigint "hot_catch_app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hot_catch_app_id"], name: "index_network_steps_on_hot_catch_app_id"
  end

  create_table "networks", force: :cascade do |t|
    t.string "name"
    t.float "bytes_in"
    t.float "bytes_out"
    t.float "packets_in"
    t.float "packets_out"
    t.datetime "get_time"
    t.bigint "hot_catch_app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hot_catch_app_id"], name: "index_networks_on_hot_catch_app_id"
  end

  create_table "role_users", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_users_on_role_id"
    t.index ["user_id"], name: "index_role_users_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "info", null: false
    t.text "full_info", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info"], name: "index_roles_on_info", unique: true
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "system_metric_steps", force: :cascade do |t|
    t.string "type"
    t.integer "count", default: 0
    t.float "cpu_average_sum", default: 0.0
    t.float "cpu_average"
    t.float "memory_used"
    t.float "memory_used_sum", default: 0.0
    t.float "swap_used"
    t.float "swap_used_sum", default: 0.0
    t.integer "descriptors_used"
    t.integer "descriptors_used_sum", default: 0
    t.datetime "get_time"
    t.bigint "hot_catch_app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hot_catch_app_id"], name: "index_system_metric_steps_on_hot_catch_app_id"
  end

  create_table "system_metrics", force: :cascade do |t|
    t.float "cpu_average"
    t.integer "memory_used"
    t.integer "swap_used"
    t.integer "descriptors_used"
    t.datetime "get_time"
    t.bigint "hot_catch_app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hot_catch_app_id"], name: "index_system_metrics_on_hot_catch_app_id"
  end

  create_table "user_requests", force: :cascade do |t|
    t.string "ip", null: false
    t.datetime "request_time", null: false
    t.bigint "main_hot_catch_log_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["main_hot_catch_log_id"], name: "index_user_requests_on_main_hot_catch_log_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

  add_foreign_key "disks", "hot_catch_apps"
  add_foreign_key "main_hot_catch_logs", "hot_catch_apps"
  add_foreign_key "main_metrics", "hot_catch_apps"
  add_foreign_key "network_steps", "hot_catch_apps"
  add_foreign_key "networks", "hot_catch_apps"
  add_foreign_key "role_users", "roles"
  add_foreign_key "role_users", "users"
  add_foreign_key "system_metric_steps", "hot_catch_apps"
  add_foreign_key "system_metrics", "hot_catch_apps"
  add_foreign_key "user_requests", "main_hot_catch_logs"
end
