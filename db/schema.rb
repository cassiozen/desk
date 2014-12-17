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

ActiveRecord::Schema.define(version: 20141217174541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "assignee_profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interactions", force: true do |t|
    t.integer  "request_id"
    t.integer  "user_id"
    t.integer  "interacteable_id"
    t.string   "interacteable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interactions", ["request_id"], name: "index_interactions_on_request_id", using: :btree
  add_index "interactions", ["user_id"], name: "index_interactions_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.text "body"
  end

  create_table "portals", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_states", force: true do |t|
    t.integer  "request_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "request_states", ["request_id"], name: "index_request_states_on_request_id", using: :btree

  create_table "requestor_profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.integer  "portal_id"
    t.integer  "requestor_id"
    t.integer  "assignee_id"
    t.datetime "due_in"
    t.hstore   "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["portal_id"], name: "index_requests_on_portal_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   default: "", null: false
    t.integer  "portal_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.string   "profile_type"
  end

  add_index "users", ["email", "portal_id"], name: "index_users_on_email_and_portal_id", unique: true, using: :btree
  add_index "users", ["profile_id"], name: "index_users_on_profile_id", using: :btree
  add_index "users", ["profile_type"], name: "index_users_on_profile_type", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
