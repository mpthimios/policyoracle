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

ActiveRecord::Schema.define(version: 20140911134416) do

  create_table "contracts", force: true do |t|
    t.string   "name",                 limit: 100
    t.decimal  "current_price",                    precision: 8, scale: 2
    t.decimal  "closing_price",                    precision: 8, scale: 2
    t.decimal  "opening_price",                    precision: 8, scale: 2
    t.datetime "opening_date"
    t.datetime "end_date"
    t.float    "total_shares"
    t.float    "total_amount_wagered"
    t.decimal  "high_price",                       precision: 8, scale: 2
    t.decimal  "low_price",                        precision: 8, scale: 2
    t.integer  "volume_traded"
    t.boolean  "status",                                                   default: false
    t.integer  "position"
    t.integer  "market_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contracts", ["market_id"], name: "index_contracts_on_market_id"

  create_table "holdings", force: true do |t|
    t.integer  "user_id"
    t.integer  "contract_id"
    t.integer  "quantity"
    t.float    "price_purchased"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holdings", ["user_id", "contract_id"], name: "index_holdings_on_user_id_and_contract_id"

  create_table "markets", force: true do |t|
    t.string   "name",             limit: 100
    t.string   "category",         limit: 32
    t.text     "description"
    t.datetime "published_date"
    t.datetime "arbitration_date"
    t.integer  "shares_to_users"
    t.integer  "mechanism"
    t.boolean  "status",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "member_date"
    t.float    "total_amount",      default: 200.0
    t.float    "cash_amount",       default: 200.0
    t.float    "investment_amount"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.boolean  "admin",             default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "utransactions", force: true do |t|
    t.integer  "quantity"
    t.datetime "date"
    t.integer  "user_id"
    t.integer  "contract_id"
    t.decimal  "value"
    t.decimal  "contract_current_value"
    t.decimal  "contract_new_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "utransactions", ["user_id", "contract_id"], name: "index_utransactions_on_user_id_and_contract_id"

end
