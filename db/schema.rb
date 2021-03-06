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

ActiveRecord::Schema.define(version: 20180624003504) do

  create_table "call_notes", force: :cascade do |t|
    t.datetime "time"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_call_notes_on_user_id"
  end

  create_table "quick_notes", force: :cascade do |t|
    t.string   "category"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.index ["user_id", "category"], name: "index_quick_notes_on_user_id_and_category"
    t.index ["user_id"], name: "index_quick_notes_on_user_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.date     "date"
    t.string   "reference"
    t.string   "vocus_ticket"
    t.string   "nbn_search"
    t.string   "service_type"
    t.integer  "priority"
    t.boolean  "complete",     default: false
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "notes"
    t.boolean  "vocus"
    t.string   "fault_type"
    t.string   "check_for"
    t.index ["user_id", "date"], name: "index_reminders_on_user_id_and_date"
    t.index ["user_id"], name: "index_reminders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
