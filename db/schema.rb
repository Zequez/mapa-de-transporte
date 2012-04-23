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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120423102527) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "is_superadmin",          :default => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "bus_groups", :force => true do |t|
    t.string  "name"
    t.integer "city_id"
    t.integer "bus_price"
    t.integer "bus_delay"
    t.integer "bus_start_time"
    t.integer "bus_end_time"
    t.integer "bus_card"
    t.integer "bus_cash"
  end

  add_index "bus_groups", ["name"], :name => "index_bus_groups_on_name"

  create_table "buses", :force => true do |t|
    t.string   "name"
    t.string   "color_1",                 :default => "#dddddd"
    t.string   "color_2",                 :default => "#222222"
    t.integer  "karma",                   :default => 0,         :null => false
    t.integer  "city_id"
    t.integer  "bus_group_id"
    t.datetime "updated_at"
    t.integer  "delay"
    t.integer  "start_time"
    t.integer  "end_time"
    t.boolean  "visible",                 :default => true,      :null => false
    t.string   "encoded_departure_route"
    t.string   "encoded_return_route"
    t.integer  "card"
    t.integer  "cash"
  end

  add_index "buses", ["name", "city_id", "bus_group_id"], :name => "index_buses_on_name_and_city_id_and_bus_group_id"

  create_table "checkpoints", :force => true do |t|
    t.float   "latitude"
    t.float   "longitude"
    t.integer "route_id"
    t.integer "number"
  end

  create_table "cities", :force => true do |t|
    t.string  "name"
    t.string  "perm"
    t.boolean "use_as_default"
    t.string  "viewport"
    t.integer "bus_price"
    t.integer "bus_delay"
    t.integer "bus_start_time"
    t.integer "bus_end_time"
    t.integer "bus_card"
    t.integer "bus_cash"
    t.boolean "show_bus_card",  :default => true, :null => false
    t.boolean "show_bus_cash",  :default => true, :null => false
  end

  add_index "cities", ["perm"], :name => "index_cities_on_perm"

  create_table "domains", :force => true do |t|
    t.string  "name"
    t.integer "city_id"
  end

  add_index "domains", ["name"], :name => "index_domains_on_name"

  create_table "routes", :force => true do |t|
    t.string  "name"
    t.text    "addresses"
    t.string  "encoded"
    t.integer "departure_bus_id"
    t.integer "return_bus_id"
  end

end
