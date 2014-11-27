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

ActiveRecord::Schema.define(version: 20141127173524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "twitter_accounts", force: true do |t|
    t.string   "screen_name"
    t.datetime "follow_start"
    t.boolean  "unfollowed",    default: false
    t.datetime "unfollowed_at"
    t.boolean  "following",     default: false
    t.boolean  "invalid",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_accounts", ["screen_name"], name: "index_twitter_accounts_on_screen_name", using: :btree

end
