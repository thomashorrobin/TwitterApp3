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

ActiveRecord::Schema.define(version: 20160207015056) do

  create_table "accounts", force: :cascade do |t|
    t.string   "username",             limit: 255
    t.string   "twitter_id",           limit: 255
    t.string   "display_name",         limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "followers_count",      limit: 4,   null: false
    t.integer  "following_count",      limit: 4,   null: false
    t.integer  "party_affiliation_id", limit: 4
  end

  add_index "accounts", ["party_affiliation_id"], name: "index_accounts_on_party_affiliation_id", using: :btree

  create_table "all_nodes", id: false, force: :cascade do |t|
    t.string "username",     limit: 255
    t.string "display_name", limit: 255
  end

  create_table "api_call_logs", force: :cascade do |t|
    t.string   "calldescription", limit: 255
    t.datetime "calldatetime"
    t.boolean  "successful"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "EndPointPath",    limit: 255
    t.string   "TwitterHandle",   limit: 255
    t.integer  "RecordsInserted", limit: 4
  end

  create_table "followers", force: :cascade do |t|
    t.string   "username",     limit: 255
    t.string   "twitter_id",   limit: 255
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "account_id",   limit: 4,   null: false
  end

  add_index "followers", ["account_id"], name: "fk_followers_accounts", using: :btree

  create_table "followings", force: :cascade do |t|
    t.string   "username",     limit: 255
    t.string   "twitter_id",   limit: 255
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "account_id",   limit: 4,   null: false
  end

  add_index "followings", ["account_id"], name: "fk_followings_accounts", using: :btree

  create_table "party_affiliations", force: :cascade do |t|
    t.string   "partyAffiliation", limit: 255
    t.string   "partyColour",      limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_foreign_key "accounts", "party_affiliations"
  add_foreign_key "followers", "accounts", name: "followers_ibfk_1"
  add_foreign_key "followings", "accounts", name: "followings_ibfk_1"
end
