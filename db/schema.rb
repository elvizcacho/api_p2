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

ActiveRecord::Schema.define(version: 20150101193243) do

  create_table "api_keys", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "controller_actions", force: true do |t|
    t.integer  "controller_action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "controller_actions_roles", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "controller_action_id"
  end

  add_index "controller_actions_roles", ["controller_action_id"], name: "index_controller_actions_roles_on_controller_action_id"
  add_index "controller_actions_roles", ["role_id"], name: "index_controller_actions_roles_on_role_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

end
