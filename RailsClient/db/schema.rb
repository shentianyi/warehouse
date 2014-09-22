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

ActiveRecord::Schema.define(version: 20140922083728) do

  create_table "api_logs", force: true do |t|
    t.string   "user_id"
    t.string   "targetable_id"
    t.string   "targetable_type"
    t.string   "action"
    t.string   "action_code"
    t.boolean  "result"
    t.string   "message"
    t.boolean  "is_delete",       default: false
    t.boolean  "is_dirty",        default: true
    t.boolean  "is_new",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_logs", ["id"], name: "index_api_logs_on_id", using: :btree
  add_index "api_logs", ["targetable_id"], name: "index_api_logs_on_targetable_id", using: :btree
  add_index "api_logs", ["user_id"], name: "index_api_logs_on_user_id", using: :btree

  create_table "attachments", force: true do |t|
    t.string   "name"
    t.string   "path"
    t.float    "size"
    t.string   "path_name"
    t.string   "attachable_id"
    t.string   "attachable_type"
    t.string   "version"
    t.text     "md5"
    t.string   "type"
    t.boolean  "is_delete",       default: false
    t.boolean  "is_dirty",        default: true
    t.boolean  "is_new",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id", using: :btree
  add_index "attachments", ["attachable_type"], name: "index_attachments_on_attachable_type", using: :btree
  add_index "attachments", ["id"], name: "index_attachments_on_id", using: :btree

  create_table "deliveries", force: true do |t|
    t.string   "uuid",           limit: 36,                 null: false
    t.integer  "state",                     default: 0,     null: false
    t.datetime "delivery_date"
    t.datetime "received_date"
    t.string   "receiver_id"
    t.string   "user_id"
    t.boolean  "is_delete",                 default: false
    t.boolean  "is_dirty",                  default: true
    t.boolean  "is_new",                    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_id"
    t.string   "destination_id"
    t.string   "remark"
  end

  add_index "deliveries", ["destination_id"], name: "index_deliveries_on_destination_id", using: :btree
  add_index "deliveries", ["id"], name: "index_deliveries_on_id", using: :btree
  add_index "deliveries", ["source_id"], name: "index_deliveries_on_source_id", using: :btree
  add_index "deliveries", ["user_id"], name: "index_deliveries_on_user_id", using: :btree
  add_index "deliveries", ["uuid"], name: "index_deliveries_on_uuid", using: :btree

  create_table "forklifts", force: true do |t|
    t.string   "uuid",        limit: 36,                 null: false
    t.integer  "state",                  default: 0,     null: false
    t.string   "delivery_id"
    t.string   "remark"
    t.string   "stocker_id"
    t.string   "user_id"
    t.boolean  "is_delete",              default: false
    t.boolean  "is_dirty",               default: true
    t.boolean  "is_new",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "whouse_id"
  end

  add_index "forklifts", ["delivery_id"], name: "index_forklifts_on_delivery_id", using: :btree
  add_index "forklifts", ["id"], name: "index_forklifts_on_id", using: :btree
  add_index "forklifts", ["stocker_id"], name: "index_forklifts_on_stocker_id", using: :btree
  add_index "forklifts", ["user_id"], name: "index_forklifts_on_user_id", using: :btree
  add_index "forklifts", ["uuid"], name: "index_forklifts_on_uuid", using: :btree
  add_index "forklifts", ["whouse_id"], name: "index_forklifts_on_whouse_id", using: :btree

  create_table "led_states", force: true do |t|
    t.integer  "state"
    t.string   "rgb"
    t.integer  "led_code"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leds", force: true do |t|
    t.string   "name"
    t.string   "signal_id"
    t.integer  "current_state"
    t.boolean  "is_delete",     default: false
    t.boolean  "is_dirty",      default: true
    t.boolean  "is_new",        default: true
    t.string   "modem_id"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mac"
  end

  add_index "leds", ["id"], name: "index_leds_on_id", using: :btree
  add_index "leds", ["modem_id"], name: "index_leds_on_modem_id", using: :btree
  add_index "leds", ["position"], name: "index_leds_on_position", using: :btree
  add_index "leds", ["signal_id"], name: "index_leds_on_signal_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "uuid",           limit: 36,                 null: false
    t.string   "name"
    t.boolean  "is_delete",                 default: false
    t.boolean  "is_dirty",                  default: true
    t.boolean  "is_new",                    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "tel"
    t.boolean  "is_base",                   default: false
    t.string   "destination_id"
  end

  add_index "locations", ["destination_id"], name: "index_locations_on_destination_id", using: :btree
  add_index "locations", ["id"], name: "index_locations_on_id", using: :btree
  add_index "locations", ["uuid"], name: "index_locations_on_uuid", using: :btree

  create_table "modems", force: true do |t|
    t.string   "name"
    t.string   "ip"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "modems", ["id"], name: "index_modems_on_id", using: :btree

  create_table "order_items", force: true do |t|
    t.string   "uuid",                         null: false
    t.float    "quantity"
    t.integer  "box_quantity", default: 0
    t.string   "order_id"
    t.string   "location_id"
    t.string   "whouse_id"
    t.string   "user_id"
    t.string   "part_id"
    t.string   "part_type_id"
    t.string   "remark"
    t.boolean  "is_emergency", default: false, null: false
    t.boolean  "is_delete",    default: false
    t.boolean  "is_dirty",     default: true
    t.boolean  "is_new",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_finished",  default: false
    t.boolean  "out_of_stock", default: false
  end

  add_index "order_items", ["id"], name: "index_order_items_on_id", using: :btree
  add_index "order_items", ["location_id"], name: "index_order_items_on_location_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["part_id"], name: "index_order_items_on_part_id", using: :btree
  add_index "order_items", ["part_type_id"], name: "index_order_items_on_part_type_id", using: :btree
  add_index "order_items", ["user_id"], name: "index_order_items_on_user_id", using: :btree
  add_index "order_items", ["uuid"], name: "index_order_items_on_uuid", using: :btree
  add_index "order_items", ["whouse_id"], name: "index_order_items_on_whouse_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "uuid",       limit: 36,                 null: false
    t.boolean  "handled",               default: false
    t.boolean  "is_delete",             default: false
    t.boolean  "is_dirty",              default: true
    t.boolean  "is_new",                default: true
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_id"
  end

  add_index "orders", ["id"], name: "index_orders_on_id", using: :btree
  add_index "orders", ["source_id"], name: "index_orders_on_source_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree
  add_index "orders", ["uuid"], name: "index_orders_on_uuid", using: :btree

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
    t.string   "uuid",                              null: false
    t.string   "part_id"
    t.float    "quantity",          default: 0.0
    t.integer  "state",             default: 0,     null: false
    t.string   "location_id"
    t.string   "user_id"
    t.string   "forklift_id"
    t.boolean  "is_delete",         default: false
    t.boolean  "is_dirty",          default: true
    t.boolean  "is_new",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "quantity_str"
    t.string   "check_in_time"
    t.string   "positionable_id"
    t.string   "positionable_type"
  end

  add_index "packages", ["forklift_id"], name: "index_packages_on_forklift_id", using: :btree
  add_index "packages", ["id"], name: "index_packages_on_id", using: :btree
  add_index "packages", ["location_id"], name: "index_packages_on_location_id", using: :btree
  add_index "packages", ["part_id"], name: "index_packages_on_part_id", using: :btree
  add_index "packages", ["positionable_id"], name: "index_packages_on_positionable_id", using: :btree
  add_index "packages", ["positionable_type"], name: "index_packages_on_positionable_type", using: :btree
  add_index "packages", ["user_id"], name: "index_packages_on_user_id", using: :btree
  add_index "packages", ["uuid"], name: "index_packages_on_uuid", using: :btree

  create_table "part_positions", force: true do |t|
    t.string   "part_id"
    t.string   "position_id"
    t.boolean  "is_delete",       default: false
    t.boolean  "is_dirty",        default: true
    t.boolean  "is_new",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sourceable_id"
    t.string   "sourceable_type"
  end

  add_index "part_positions", ["id"], name: "index_part_positions_on_id", using: :btree
  add_index "part_positions", ["part_id"], name: "index_part_positions_on_part_id", using: :btree
  add_index "part_positions", ["position_id"], name: "index_part_positions_on_position_id", using: :btree
  add_index "part_positions", ["sourceable_id"], name: "index_part_positions_on_sourceable_id", using: :btree
  add_index "part_positions", ["sourceable_type"], name: "index_part_positions_on_sourceable_type", using: :btree

  create_table "part_types", force: true do |t|
    t.string   "name"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_types", ["id"], name: "index_part_types_on_id", using: :btree

  create_table "parts", force: true do |t|
    t.string   "uuid",         limit: 36,                 null: false
    t.string   "customernum"
    t.string   "user_id"
    t.boolean  "is_delete",               default: false
    t.boolean  "is_dirty",                default: true
    t.boolean  "is_new",                  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "unit_pack"
    t.string   "part_type_id"
  end

  add_index "parts", ["id"], name: "index_parts_on_id", using: :btree
  add_index "parts", ["part_type_id"], name: "index_parts_on_part_type_id", using: :btree
  add_index "parts", ["user_id"], name: "index_parts_on_user_id", using: :btree
  add_index "parts", ["uuid"], name: "index_parts_on_uuid", using: :btree

  create_table "pick_item_filters", force: true do |t|
    t.string   "user_id"
    t.string   "value"
    t.string   "filterable_id"
    t.string   "filterable_type"
    t.boolean  "is_delete",       default: false
    t.boolean  "is_dirty",        default: true
    t.boolean  "is_new",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pick_item_filters", ["filterable_id"], name: "index_pick_item_filters_on_filterable_id", using: :btree
  add_index "pick_item_filters", ["filterable_type"], name: "index_pick_item_filters_on_filterable_type", using: :btree
  add_index "pick_item_filters", ["id"], name: "index_pick_item_filters_on_id", using: :btree
  add_index "pick_item_filters", ["user_id"], name: "index_pick_item_filters_on_user_id", using: :btree

  create_table "pick_items", force: true do |t|
    t.string   "pick_list_id"
    t.float    "quantity",              default: 0.0
    t.integer  "box_quantity",          default: 0
    t.string   "destination_whouse_id"
    t.string   "user_id"
    t.string   "part_id"
    t.string   "part_type_id"
    t.string   "remark"
    t.boolean  "is_emergency",          default: false, null: false
    t.boolean  "is_delete",             default: false
    t.boolean  "is_dirty",              default: true
    t.boolean  "is_new",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "order_item_id"
  end

  add_index "pick_items", ["destination_whouse_id"], name: "index_pick_items_on_destination_whouse_id", using: :btree
  add_index "pick_items", ["id"], name: "index_pick_items_on_id", using: :btree
  add_index "pick_items", ["order_item_id"], name: "index_pick_items_on_order_item_id", using: :btree
  add_index "pick_items", ["pick_list_id"], name: "index_pick_items_on_pick_list_id", using: :btree

  create_table "pick_lists", force: true do |t|
    t.string   "user_id"
    t.integer  "state"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pick_lists", ["id"], name: "index_pick_lists_on_id", using: :btree
  add_index "pick_lists", ["user_id"], name: "index_pick_lists_on_user_id", using: :btree

  create_table "positions", force: true do |t|
    t.string   "uuid",       limit: 36,                 null: false
    t.string   "whouse_id"
    t.string   "detail"
    t.boolean  "is_delete",             default: false
    t.boolean  "is_dirty",              default: true
    t.boolean  "is_new",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["id"], name: "index_positions_on_id", using: :btree
  add_index "positions", ["uuid"], name: "index_positions_on_uuid", using: :btree
  add_index "positions", ["whouse_id"], name: "index_positions_on_whouse_id", using: :btree

  create_table "regexes", force: true do |t|
    t.string   "name",                           null: false
    t.string   "code",                           null: false
    t.integer  "prefix_length",  default: 0
    t.string   "prefix_string"
    t.integer  "type",                           null: false
    t.integer  "suffix_length",  default: 0
    t.integer  "suffix_string"
    t.string   "regex_string",   default: ""
    t.string   "regexable_id"
    t.string   "regexable_type"
    t.string   "remark"
    t.boolean  "is_sys_default", default: false
    t.boolean  "is_delete",      default: false
    t.boolean  "is_dirty",       default: true
    t.boolean  "is_new",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regexes", ["id"], name: "index_regexes_on_id", using: :btree
  add_index "regexes", ["regexable_id"], name: "index_regexes_on_regexable_id", using: :btree
  add_index "regexes", ["regexable_type"], name: "index_regexes_on_regexable_type", using: :btree

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

  create_table "sync_pools", force: true do |t|
    t.string   "table_name"
    t.boolean  "locked",     default: true
    t.string   "client_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sys_configs", force: true do |t|
    t.string   "code"
    t.string   "value"
    t.string   "name"
    t.string   "remark"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sys_configs", ["code"], name: "index_sys_configs_on_code", using: :btree
  add_index "sys_configs", ["id"], name: "index_sys_configs_on_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "uuid",                   limit: 36,                 null: false
    t.boolean  "is_delete",                         default: false
    t.boolean  "is_dirty",                          default: true
    t.boolean  "is_new",                            default: true
    t.string   "name"
    t.string   "tel"
    t.string   "email"
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location_id"
    t.string   "authentication_token"
    t.integer  "role_id",                           default: 100,   null: false
    t.boolean  "is_sys",                            default: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["id"], name: "index_users_on_id", using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", using: :btree

  create_table "whouses", force: true do |t|
    t.string   "uuid",        limit: 36,                 null: false
    t.string   "name"
    t.string   "location_id"
    t.boolean  "is_delete",              default: false
    t.boolean  "is_dirty",               default: true
    t.boolean  "is_new",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "whouses", ["id"], name: "index_whouses_on_id", using: :btree
  add_index "whouses", ["location_id"], name: "index_whouses_on_location_id", using: :btree
  add_index "whouses", ["uuid"], name: "index_whouses_on_uuid", using: :btree

end
