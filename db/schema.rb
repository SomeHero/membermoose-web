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

ActiveRecord::Schema.define(version: 20151201073539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_payment_processor_oauths", force: true do |t|
    t.integer  "account_id"
    t.integer  "payment_processor_id"
    t.text     "raw_response"
    t.string   "oauth_user_id"
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.string   "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_payment_processor_id"
  end

  add_index "account_payment_processor_oauths", ["account_id"], name: "index_account_payment_processor_oauths_on_account_id", using: :btree
  add_index "account_payment_processor_oauths", ["account_payment_processor_id"], name: "oauth_index", unique: true, using: :btree
  add_index "account_payment_processor_oauths", ["payment_processor_id"], name: "index_account_payment_processor_oauths_on_payment_processor_id", using: :btree

  create_table "account_payment_processors", force: true do |t|
    t.integer  "account_id"
    t.integer  "payment_processor_id"
    t.json     "raw_response"
    t.string   "oauth_user_id"
    t.string   "refresh_token"
    t.string   "api_key"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.string   "secret_token"
  end

  add_index "account_payment_processors", ["account_id"], name: "index_account_payment_processors_on_account_id", using: :btree
  add_index "account_payment_processors", ["payment_processor_id"], name: "index_account_payment_processors_on_payment_processor_id", using: :btree

  create_table "accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.string   "phone_number"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "subdomain"
    t.string   "guid"
    t.string   "stripe_customer_id"
    t.string   "site_url"
    t.boolean  "has_uploaded_logo",    default: false
    t.boolean  "has_setup_subdomain",  default: false
    t.boolean  "has_created_plan",     default: false
    t.boolean  "has_connected_stripe", default: false
    t.boolean  "has_upgraded_plan",    default: false
    t.integer  "role",                 default: 0
    t.integer  "bull_id"
    t.datetime "member_since",         default: '2015-11-29 06:23:58'
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state_code"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "addresses", ["account_id"], name: "index_addresses_on_account_id", using: :btree

  create_table "admin_users", force: true do |t|
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
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "cards", force: true do |t|
    t.integer  "account_id"
    t.string   "brand"
    t.string   "last4"
    t.integer  "expiration_month"
    t.integer  "expiration_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_id"
    t.boolean  "deleted",          default: false
    t.datetime "deleted_at"
    t.string   "name_on_card"
    t.boolean  "default",          default: false
  end

  add_index "cards", ["account_id"], name: "index_cards_on_account_id", using: :btree

  create_table "charges", force: true do |t|
    t.string   "status"
    t.decimal  "amount"
    t.string   "currency"
    t.integer  "card_id"
    t.string   "external_invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_id"
    t.string   "external_id"
  end

  add_index "charges", ["card_id"], name: "index_charges_on_card_id", using: :btree

  create_table "invoices", force: true do |t|
    t.string   "external_id"
    t.decimal  "subtotal"
    t.decimal  "total"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.datetime "due_date"
  end

  add_index "invoices", ["subscription_id"], name: "index_invoices_on_subscription_id", using: :btree

  create_table "payment_processors", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "account_id"
    t.decimal  "amount"
    t.decimal  "payment_processor_fee"
    t.string   "payment_type"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid"
    t.string   "external_id"
    t.integer  "card_id"
    t.string   "payment_method"
    t.string   "comments"
    t.integer  "subscription_id"
    t.integer  "payment_processor_id"
    t.integer  "payee_id"
    t.datetime "transaction_date",      default: '2015-11-28 17:42:12'
  end

  add_index "payments", ["account_id"], name: "index_payments_on_account_id", using: :btree
  add_index "payments", ["card_id"], name: "index_payments_on_card_id", using: :btree
  add_index "payments", ["subscription_id"], name: "index_payments_on_subscription_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "amount"
    t.string   "billing_cycle"
    t.string   "billing_interval"
    t.integer  "trial_period_days"
    t.text     "terms_and_conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "public"
    t.string   "currency"
    t.string   "guid"
    t.string   "stripe_id"
    t.boolean  "needs_sync",           default: false
    t.string   "feature_1"
    t.string   "feature_2"
    t.string   "feature_3"
    t.string   "feature_4"
    t.string   "mm_identifier"
    t.boolean  "deleted",              default: false
    t.datetime "deleted_at"
  end

  add_index "plans", ["account_id"], name: "index_plans_on_account_id", using: :btree

  create_table "stripe_webhooks", force: true do |t|
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscription_payments", force: true do |t|
    t.integer  "subscription_id"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscription_payments", ["payment_id"], name: "index_subscription_payments_on_payment_id", using: :btree
  add_index "subscription_payments", ["subscription_id"], name: "index_subscription_payments_on_subscription_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "account_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_payment_processor_id"
    t.string   "guid"
    t.string   "stripe_id"
    t.integer  "card_id"
    t.integer  "status",                       default: 1
    t.datetime "next_invoice_date"
  end

  add_index "subscriptions", ["account_id"], name: "index_subscriptions_on_account_id", using: :btree
  add_index "subscriptions", ["account_payment_processor_id"], name: "index_subscriptions_on_account_payment_processor_id", using: :btree
  add_index "subscriptions", ["card_id"], name: "index_subscriptions_on_card_id", using: :btree
  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree

  create_table "users", force: true do |t|
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
