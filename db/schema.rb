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

ActiveRecord::Schema.define(version: 20150328122150) do

  create_table "eyes", force: :cascade do |t|
    t.integer  "seq",                 limit: 4,   default: 0
    t.string   "login",               limit: 255,             null: false
    t.string   "crypted_password",    limit: 255,             null: false
    t.string   "password_salt",       limit: 255,             null: false
    t.string   "persistence_token",   limit: 255,             null: false
    t.string   "single_access_token", limit: 255,             null: false
    t.string   "perishable_token",    limit: 255,             null: false
    t.integer  "login_count",         limit: 4,   default: 0, null: false
    t.integer  "failed_login_count",  limit: 4,   default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 255
    t.string   "last_login_ip",       limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "name",                limit: 255
    t.string   "uuid",                limit: 255,             null: false
  end

  create_table "media_segments", force: :cascade do |t|
    t.integer  "duration",         limit: 4,   default: 0
    t.string   "segment",          limit: 255
    t.string   "comment",          limit: 255
    t.integer  "byterange_length", limit: 4
    t.integer  "byterange_start",  limit: 4
    t.integer  "timestamp",        limit: 4,   default: 0
    t.integer  "eye_id",           limit: 4
    t.integer  "seq",              limit: 4,   default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "media_segments", ["eye_id", "timestamp"], name: "index_media_segments_on_eye_id_and_timestamp", using: :btree

end
