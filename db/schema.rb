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

ActiveRecord::Schema.define(version: 20150928073540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "notebooks", force: :cascade do |t|
    t.string   "note_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id",                               null: false
    t.string   "title",        limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content_html"
    t.string   "share_id",     limit: 255
    t.integer  "tag_ids",                  default: [],              array: true
  end

  add_index "notes", ["share_id"], name: "index_notes_on_share_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "email",         limit: 255
    t.string   "password_hash", limit: 255
    t.string   "password_salt", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
