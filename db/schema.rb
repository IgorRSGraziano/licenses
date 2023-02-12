# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_12_170429) do
  create_table "clients", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "brand"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.boolean "active", default: true
    t.index ["token"], name: "index_clients_on_token", unique: true
  end

  create_table "customers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "description"
    t.string "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.index ["client_id"], name: "index_customers_on_client_id"
  end

  create_table "licenses", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "key"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id"
    t.bigint "payment_id"
    t.bigint "client_id", null: false
    t.index ["client_id"], name: "index_licenses_on_client_id"
    t.index ["customer_id"], name: "index_licenses_on_customer_id"
    t.index ["payment_id"], name: "index_licenses_on_payment_id"
  end

  create_table "parameters", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parameters_clients", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "value"
    t.bigint "client_id", null: false
    t.bigint "parameter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "parameter_id"], name: "index_parameters_clients_on_client_id_and_parameter_id", unique: true
    t.index ["client_id"], name: "index_parameters_clients_on_client_id"
    t.index ["parameter_id"], name: "index_parameters_clients_on_parameter_id"
  end

  create_table "payment_integrations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "billing_type"
    t.string "external_id"
    t.integer "installment"
    t.decimal "value", precision: 10
    t.string "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payment_integration_id", null: false
    t.index ["payment_integration_id"], name: "index_payments_on_payment_integration_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "username"
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.boolean "admin", default: false
    t.index ["client_id"], name: "index_users_on_client_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "customers", "clients"
  add_foreign_key "licenses", "clients"
  add_foreign_key "licenses", "customers"
  add_foreign_key "licenses", "payments"
  add_foreign_key "parameters_clients", "clients"
  add_foreign_key "parameters_clients", "parameters"
  add_foreign_key "payments", "payment_integrations"
  add_foreign_key "users", "clients"
end
