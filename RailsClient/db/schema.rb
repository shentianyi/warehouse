# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140611063003) do

  create_table "deliveries", force: true do |t|
    t.integer  "state",         default: 1,     null: false
    t.datetime "delivery_date"
    t.string   "user_id"
    t.boolean  "is_delete",     default: false
    t.boolean  "is_dirty",      default: true
    t.boolean  "is_new",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deliveries", ["id"], name: "index_deliveries_on_id", using: :btree
  add_index "deliveries", ["user_id"], name: "index_deliveries_on_user_id", using: :btree

  create_table "fortlifts", force: true do |t|
    t.integer  "state",       default: 1,     null: false
    t.string   "delivery_id"
    t.string   "remark"
    t.string   "stocker"
    t.string   "whouse"
    t.boolean  "is_delete",   default: false
    t.boolean  "is_dirty",    default: true
    t.boolean  "is_new",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fortlifts", ["delivery_id"], name: "index_fortlifts_on_delivery_id", using: :btree
  add_index "fortlifts", ["id"], name: "index_fortlifts_on_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "tel"
  end

  add_index "locations", ["id"], name: "index_locations_on_id", using: :btree

  create_table "package_positions", force: true do |t|
    t.string   "position_id"
    t.string   "package_id"
    t.boolean  "is_delete",   default: false
    t.boolean  "is_dirty",    default: true
    t.boolean  "is_new",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "package_positions", ["id"], name: "index_package_positions_on_id", using: :btree
  add_index "package_positions", ["package_id"], name: "index_package_positions_on_package_id", using: :btree
  add_index "package_positions", ["position_id"], name: "index_package_positions_on_position_id", using: :btree

  create_table "packages", force: true do |t|
    t.string   "partnum"
    t.integer  "quantity",    default: 0
    t.datetime "in_date"
    t.string   "fortlift_id"
    t.integer  "state",       default: 1,     null: false
    t.string   "location_id"
    t.boolean  "is_delete",   default: false
    t.boolean  "is_dirty",    default: true
    t.boolean  "is_new",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "packages", ["fortlift_id"], name: "index_packages_on_fortlift_id", using: :btree
  add_index "packages", ["id"], name: "index_packages_on_id", using: :btree
  add_index "packages", ["location_id"], name: "index_packages_on_location_id", using: :btree

  create_table "part_positions", force: true do |t|
    t.string   "partnum"
    t.string   "position_id"
    t.string   "position_detail"
    t.string   "whouse_name"
    t.string   "whouse_id"
    t.boolean  "is_delete",       default: false
    t.boolean  "is_dirty",        default: true
    t.boolean  "is_new",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_positions", ["id"], name: "index_part_positions_on_id", using: :btree
  add_index "part_positions", ["partnum"], name: "index_part_positions_on_partnum", using: :btree
  add_index "part_positions", ["position_id"], name: "index_part_positions_on_position_id", using: :btree
  add_index "part_positions", ["whouse_id"], name: "index_part_positions_on_whouse_id", using: :btree

  create_table "parts", force: true do |t|
    t.string   "partnum"
    t.string   "customernum"
    t.boolean  "is_delete",   default: false
    t.boolean  "is_dirty",    default: true
    t.boolean  "is_new",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["id"], name: "index_parts_on_id", using: :btree
  add_index "parts", ["partnum"], name: "index_parts_on_partnum", using: :btree

  create_table "positions", force: true do |t|
    t.string   "whouse_id"
    t.string   "detail"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["id"], name: "index_positions_on_id", using: :btree
  add_index "positions", ["whouse_id"], name: "index_positions_on_whouse_id", using: :btree

  create_table "state_logs", force: true do |t|
    t.string   "stateable_id"
    t.string   "stateable_type"
    t.boolean  "is_delete",      default: false
    t.boolean  "is_dirty",       default: true
    t.boolean  "is_new",         default: true
    t.integer  "state_before"
    t.integer  "state_after"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "state_logs", ["id"], name: "index_state_logs_on_id", using: :btree

  create_table "users", force: true do |t|
    t.boolean  "is_delete",              default: false
    t.boolean  "is_dirty",               default: true
    t.boolean  "is_new",                 default: true
    t.string   "name"
    t.string   "tel"
    t.string   "email"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location_id"
    t.string   "authentication_token"
    t.string   "user_no",                default: "",    null: false
    t.integer  "role_id",                default: 100,   null: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["id"], name: "index_users_on_id", using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_no"], name: "index_users_on_user_no", unique: true, using: :btree

  create_table "whouses", force: true do |t|
    t.string   "name"
    t.string   "location_id"
    t.boolean  "is_delete",   default: false
    t.boolean  "is_dirty",    default: true
    t.boolean  "is_new",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "whouses", ["id"], name: "index_whouses_on_id", using: :btree
  add_index "whouses", ["location_id"], name: "index_whouses_on_location_id", using: :btree

end
