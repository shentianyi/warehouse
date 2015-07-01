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

ActiveRecord::Schema.define(version: 20150629025042) do

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

  create_table "containers", force: true do |t|
    t.string   "custom_id",                 limit: 36
    t.integer  "type"
    t.float    "quantity"
    t.integer  "state"
    t.string   "location_id"
    t.string   "user_id"
    t.string   "current_positionable_id"
    t.string   "current_positionable_type"
    t.datetime "fifo_time"
    t.string   "remark"
    t.string   "part_id"
    t.boolean  "is_delete",                            default: false
    t.boolean  "is_dirty",                             default: true
    t.boolean  "is_new",                               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "part_id_display"
    t.string   "quantity_display"
    t.string   "fifo_time_display"
  end

  add_index "containers", ["current_positionable_id"], name: "index_containers_on_current_positionable_id", using: :btree
  add_index "containers", ["current_positionable_type"], name: "index_containers_on_current_positionable_type", using: :btree
  add_index "containers", ["custom_id"], name: "index_containers_on_custom_id", using: :btree
  add_index "containers", ["id"], name: "index_containers_on_id", using: :btree
  add_index "containers", ["is_delete"], name: "index_containers_on_is_delete", using: :btree
  add_index "containers", ["location_id"], name: "index_containers_on_location_id", using: :btree
  add_index "containers", ["part_id"], name: "index_containers_on_part_id", using: :btree
  add_index "containers", ["type"], name: "index_containers_on_type", using: :btree
  add_index "containers", ["user_id"], name: "index_containers_on_user_id", using: :btree

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

  create_table "inventory_list_items", force: true do |t|
    t.string   "package_id"
    t.string   "unique_id"
    t.string   "part_id"
    t.decimal  "qty",               precision: 20, scale: 10
    t.string   "position"
    t.string   "current_whouse"
    t.string   "current_position"
    t.string   "user_id"
    t.boolean  "in_store",                                    default: false
    t.integer  "inventory_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "whouse_id"
    t.datetime "fifo"
    t.string   "part_wire_mark"
    t.string   "part_form_mark"
    t.decimal  "origin_qty",        precision: 20, scale: 10
    t.boolean  "need_convert",                                default: false
    t.boolean  "locked",                                      default: false
    t.boolean  "in_stored",                                   default: false
  end

  create_table "inventory_lists", force: true do |t|
    t.string   "name"
    t.integer  "state",      default: 100
    t.string   "whouse_id"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "location_container_hierarchies", id: false, force: true do |t|
    t.string   "ancestor_id",                   null: false
    t.string   "descendant_id",                 null: false
    t.integer  "generations",                   null: false
    t.boolean  "is_delete",     default: false
    t.boolean  "is_dirty",      default: true
    t.boolean  "is_new",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "location_container_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "anc_desc_idx", unique: true, using: :btree
  add_index "location_container_hierarchies", ["descendant_id"], name: "desc_idx", using: :btree

  create_table "location_containers", force: true do |t|
    t.string   "source_location_id"
    t.string   "des_location_id"
    t.string   "user_id"
    t.string   "container_id"
    t.string   "remark"
    t.integer  "type"
    t.boolean  "is_delete",            default: false
    t.boolean  "is_dirty",             default: true
    t.boolean  "is_new",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",                default: 0
    t.string   "destinationable_id"
    t.string   "destinationable_type"
    t.string   "ancestry"
  end

  add_index "location_containers", ["ancestry"], name: "index_location_containers_on_ancestry", using: :btree
  add_index "location_containers", ["container_id"], name: "index_location_containers_on_container_id", using: :btree
  add_index "location_containers", ["des_location_id"], name: "index_location_containers_on_des_location_id", using: :btree
  add_index "location_containers", ["destinationable_id"], name: "index_location_containers_on_destinationable_id", using: :btree
  add_index "location_containers", ["destinationable_type"], name: "index_location_containers_on_destinationable_type", using: :btree
  add_index "location_containers", ["id"], name: "index_location_containers_on_id", using: :btree
  add_index "location_containers", ["source_location_id"], name: "index_location_containers_on_source_location_id", using: :btree

  create_table "location_destinations", force: true do |t|
    t.string   "location_id"
    t.string   "destination_id"
    t.boolean  "is_default",     default: false
    t.boolean  "is_delete",      default: false
    t.boolean  "is_dirty",       default: true
    t.boolean  "is_new",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "location_destinations", ["destination_id"], name: "index_location_destinations_on_destination_id", using: :btree
  add_index "location_destinations", ["id"], name: "index_location_destinations_on_id", using: :btree
  add_index "location_destinations", ["location_id"], name: "index_location_destinations_on_location_id", using: :btree

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
    t.integer  "parent_id"
    t.integer  "status",                    default: 0
    t.string   "remark",                    default: ""
  end

  add_index "locations", ["destination_id"], name: "index_locations_on_destination_id", using: :btree
  add_index "locations", ["id"], name: "index_locations_on_id", using: :btree
  add_index "locations", ["parent_id"], name: "index_locations_on_parent_id", using: :btree
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

  create_table "move_types", force: true do |t|
    t.string   "typeId"
    t.string   "short_desc"
    t.text     "long_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movements", force: true do |t|
    t.string   "partNr"
    t.datetime "fifo"
    t.string   "from_id"
    t.string   "fromPosition"
    t.string   "to_id"
    t.string   "toPosition"
    t.string   "packageId"
    t.string   "uniqueId"
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "qty",          precision: 20, scale: 10
    t.string   "remarks"
    t.string   "employee_id"
    t.string   "remark"
  end

  add_index "movements", ["packageId"], name: "package_id_index", using: :btree
  add_index "movements", ["type_id"], name: "index_movements_on_type_id", using: :btree
  add_index "movements", ["uniqueId"], name: "unique_id_unique", unique: true, using: :btree

  create_table "n_locations", force: true do |t|
    t.string   "locationId"
    t.string   "name"
    t.string   "remark",     default: ""
    t.integer  "status",     default: 0
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "n_locations", ["locationId"], name: "location_id_unique", unique: true, using: :btree
  add_index "n_locations", ["parent_id"], name: "index_n_locations_on_parent_id", using: :btree

  create_table "n_storages", force: true do |t|
    t.string   "storageId"
    t.string   "partNr"
    t.datetime "fifo"
    t.string   "position"
    t.string   "packageId"
    t.string   "uniqueId"
    t.string   "ware_house_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "qty",           precision: 20, scale: 10
    t.boolean  "locked",                                  default: false
  end

  add_index "n_storages", ["packageId"], name: "package_id_index", using: :btree
  add_index "n_storages", ["storageId"], name: "storage_id_unique", unique: true, using: :btree
  add_index "n_storages", ["uniqueId"], name: "unique_id_unique", unique: true, using: :btree
  add_index "n_storages", ["ware_house_id"], name: "index_n_storages_on_ware_house_id", using: :btree

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
    t.boolean  "handled",      default: false
    t.integer  "state",        default: 0
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
    t.string   "uuid",               limit: 36,                 null: false
    t.boolean  "handled",                       default: false
    t.boolean  "is_delete",                     default: false
    t.boolean  "is_dirty",                      default: true
    t.boolean  "is_new",                        default: true
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_id"
    t.integer  "status",                        default: 0
    t.text     "remark"
    t.string   "source_location_id"
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
    t.string   "uuid",         limit: 36,                                           null: false
    t.string   "customernum"
    t.string   "user_id"
    t.boolean  "is_delete",                                         default: false
    t.boolean  "is_dirty",                                          default: true
    t.boolean  "is_new",                                            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "unit_pack"
    t.string   "part_type_id"
    t.decimal  "convert_unit",            precision: 20, scale: 10, default: 1.0
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
    t.integer  "state",                 default: 0
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
    t.text     "order_ids"
    t.text     "remark"
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

  create_table "records", force: true do |t|
    t.string   "recordable_id"
    t.string   "recordable_type"
    t.string   "impl_id"
    t.integer  "impl_user_type"
    t.string   "impl_action"
    t.datetime "impl_time"
    t.string   "destinationable_id"
    t.string   "destinationable_type"
    t.boolean  "is_delete",            default: false
    t.boolean  "is_dirty",             default: true
    t.boolean  "is_new",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "records", ["id"], name: "index_records_on_id", using: :btree
  add_index "records", ["impl_id"], name: "index_records_on_impl_id", using: :btree
  add_index "records", ["recordable_id"], name: "index_records_on_recordable_id", using: :btree

  create_table "regex_categories", force: true do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "type"
    t.boolean  "is_delete",  default: false
    t.boolean  "is_dirty",   default: true
    t.boolean  "is_new",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regex_categories", ["id"], name: "index_regex_categories_on_id", using: :btree

  create_table "regexes", force: true do |t|
    t.string   "name",                              null: false
    t.string   "code",                              null: false
    t.integer  "prefix_length",     default: 0
    t.string   "prefix_string"
    t.integer  "type"
    t.integer  "suffix_length",     default: 0
    t.integer  "suffix_string"
    t.string   "regex_string",      default: ""
    t.string   "regexable_id"
    t.string   "regexable_type"
    t.string   "remark"
    t.boolean  "is_sys_default",    default: false
    t.boolean  "is_delete",         default: false
    t.boolean  "is_dirty",          default: true
    t.boolean  "is_new",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "regex_category_id"
  end

  add_index "regexes", ["id"], name: "index_regexes_on_id", using: :btree
  add_index "regexes", ["regex_category_id"], name: "index_regexes_on_regex_category_id", using: :btree
  add_index "regexes", ["regexable_id"], name: "index_regexes_on_regexable_id", using: :btree
  add_index "regexes", ["regexable_type"], name: "index_regexes_on_regexable_type", using: :btree

  create_table "scrap_list_items", force: true do |t|
    t.integer  "scrap_list_id"
    t.string   "part_id"
    t.string   "product_id"
    t.decimal  "quantity",      precision: 20, scale: 10
    t.string   "IU"
    t.string   "reason"
    t.string   "name"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",                                   default: 100
  end

  create_table "scrap_lists", force: true do |t|
    t.string   "src_warehouse"
    t.string   "dse_warehouse"
    t.string   "builder"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

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

  create_table "storages", force: true do |t|
    t.string   "location_id"
    t.string   "part_id"
    t.float    "quantity"
    t.datetime "fifo_time"
    t.string   "storable_id"
    t.string   "storable_type"
    t.boolean  "is_delete",     default: false
    t.boolean  "is_dirty",      default: true
    t.boolean  "is_new",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storages", ["id"], name: "index_storages_on_id", using: :btree
  add_index "storages", ["location_id"], name: "index_storages_on_location_id", using: :btree
  add_index "storages", ["part_id"], name: "index_storages_on_part_id", using: :btree
  add_index "storages", ["storable_id"], name: "index_storages_on_storable_id", using: :btree
  add_index "storages", ["storable_type"], name: "index_storages_on_storable_type", using: :btree

  create_table "sync_logs", force: true do |t|
    t.string   "table_name"
    t.boolean  "sync",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "user_name"
    t.integer  "operation_mode",                    default: 0
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["id"], name: "index_users_on_id", using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", using: :btree

  create_table "ware_houses", force: true do |t|
    t.string   "whId"
    t.string   "name"
    t.integer  "location_id"
    t.string   "positionPattern", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ware_houses", ["location_id"], name: "index_ware_houses_on_location_id", using: :btree
  add_index "ware_houses", ["whId"], name: "wh_id_unique", unique: true, using: :btree

  create_table "whouses", force: true do |t|
    t.string   "uuid",             limit: 36,                 null: false
    t.string   "name"
    t.string   "location_id"
    t.boolean  "is_delete",                   default: false
    t.boolean  "is_dirty",                    default: true
    t.boolean  "is_new",                      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position_pattern",            default: ""
  end

  add_index "whouses", ["id"], name: "index_whouses_on_id", using: :btree
  add_index "whouses", ["location_id"], name: "index_whouses_on_location_id", using: :btree
  add_index "whouses", ["uuid"], name: "index_whouses_on_uuid", using: :btree

end
