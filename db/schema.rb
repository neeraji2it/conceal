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

ActiveRecord::Schema.define(version: 20140228061746) do

  create_table "cities", force: true do |t|
    t.string   "zipcode"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "city"
    t.string   "state"
    t.string   "state_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.string   "action"
    t.float    "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.string   "address"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "customer_profile_id"
    t.string   "customer_payment_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "city"
    t.float    "fair_price"
    t.float    "one_time_donation"
    t.string   "name"
    t.string   "email"
    t.string   "status",            default: "Pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
