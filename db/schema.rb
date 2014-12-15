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

ActiveRecord::Schema.define(version: 20141214191654) do

  create_table "bhistories", force: true do |t|
    t.integer  "user_id"
    t.integer  "contract_id"
    t.decimal  "profit",      precision: 6, scale: 4, default: 0.0
    t.decimal  "loss",        precision: 6, scale: 4, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bhistories", ["user_id", "contract_id"], name: "index_bhistories_on_user_id_and_contract_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["tenant_id"], name: "index_categories_on_tenant_id", using: :btree

  create_table "contracts", force: true do |t|
    t.string   "name"
    t.decimal  "current_price",        precision: 15, scale: 8, default: 0.0
    t.decimal  "closing_price",        precision: 15, scale: 8, default: 0.0
    t.decimal  "opening_price",        precision: 15, scale: 8
    t.datetime "opening_date"
    t.datetime "end_date"
    t.integer  "total_shares",                                  default: 0
    t.decimal  "total_amount_wagered", precision: 15, scale: 8, default: 0.0
    t.integer  "volume_traded",                                 default: 0
    t.boolean  "status",                                        default: false
    t.integer  "market_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contracts", ["market_id"], name: "index_contracts_on_market_id", using: :btree

  create_table "holdings", force: true do |t|
    t.integer  "user_id"
    t.integer  "contract_id"
    t.integer  "quantity",                              default: 0
    t.decimal  "amount_spent", precision: 15, scale: 8, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holdings", ["user_id", "contract_id"], name: "index_holdings_on_user_id_and_contract_id", using: :btree

  create_table "markets", force: true do |t|
    t.text     "name"
    t.string   "category"
    t.text     "description"
    t.string   "market_type"
    t.datetime "published_date"
    t.datetime "arbitration_date"
    t.integer  "shares_to_users",             default: 0
    t.string   "mechanism",                   default: "AMM"
    t.boolean  "status",                      default: false
    t.float    "b_value",          limit: 24, default: 10.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tenant_id"
    t.string   "tags"
  end

  add_index "markets", ["tenant_id"], name: "index_markets_on_tenant_id", using: :btree

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "market_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["market_id"], name: "index_microposts_on_market_id", using: :btree
  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "tenants", force: true do |t|
    t.string   "name"
    t.string   "host"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pitch_text"
  end

  add_index "tenants", ["host"], name: "index_tenants_on_host", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.decimal  "total_amount",      precision: 15, scale: 8, default: 200.0
    t.decimal  "cash_amount",       precision: 15, scale: 8, default: 200.0
    t.decimal  "investment_amount", precision: 15, scale: 8, default: 0.0
    t.integer  "rank",                                       default: 0
    t.string   "remember_token"
    t.boolean  "admin",                                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",                                  default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "tenant_id"
    t.string   "country"
    t.string   "gender"
    t.integer  "birth_year"
    t.string   "education"
    t.string   "market_knowledge"
  end

  add_index "users", ["email", "tenant_id"], name: "index_users_on_email_and_tenant_id", using: :btree
  add_index "users", ["name", "tenant_id"], name: "index_users_on_name_and_tenant_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["tenant_id"], name: "index_users_on_tenant_id", using: :btree

  create_table "utransactions", force: true do |t|
    t.integer  "quantity",                                                  default: 0
    t.integer  "user_id"
    t.integer  "contract_id"
    t.decimal  "contract_current_value",           precision: 15, scale: 8, default: 0.0
    t.decimal  "contract_new_value",               precision: 15, scale: 8, default: 0.0
    t.decimal  "cost",                             precision: 15, scale: 8, default: 0.0
    t.string   "transaction_type",       limit: 1,                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "new_contract_values"
    t.integer  "market_id"
    t.string   "comment"
    t.integer  "tenant_id"
  end

  add_index "utransactions", ["tenant_id"], name: "index_utransactions_on_tenant_id", using: :btree
  add_index "utransactions", ["user_id", "contract_id"], name: "index_utransactions_on_user_id_and_contract_id", using: :btree

end
