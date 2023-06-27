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

ActiveRecord::Schema[7.0].define(version: 2023_06_03_125818) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "point_presences", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.string "state"
    t.string "schedule_time"
    t.string "latitude"
    t.string "longitude"
    t.string "local_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_point_presences_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.string "role_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_roles_on_company_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.integer "start_time_hour"
    t.integer "start_time_minute"
    t.integer "initial_interval_hour"
    t.integer "initial_interval_minute"
    t.integer "final_interval_hour"
    t.integer "final_interval_minute"
    t.integer "final_time_hour"
    t.integer "final_time_minute"
    t.boolean "monday", default: false, null: false
    t.boolean "tuesday", default: false, null: false
    t.boolean "wednesday", default: false, null: false
    t.boolean "thursday", default: false, null: false
    t.boolean "friday", default: false, null: false
    t.boolean "saturday", default: false, null: false
    t.boolean "sunday", default: false, null: false
    t.datetime "closing_date"
    t.datetime "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_schedules_on_role_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.jsonb "authentication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "point_presences", "roles"
  add_foreign_key "roles", "companies"
  add_foreign_key "roles", "users"
  add_foreign_key "schedules", "roles"
end
