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

ActiveRecord::Schema[7.0].define(version: 2022_11_07_001927) do
  create_table "customers", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "description"
    t.string "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "licenses", charset: "utf8mb4", force: :cascade do |t|
    t.string "key"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id"
    t.bigint "payment_id"
    t.index ["customer_id"], name: "index_licenses_on_customer_id"
    t.index ["payment_id"], name: "index_licenses_on_payment_id"
  end

  create_table "payments", charset: "utf8mb4", force: :cascade do |t|
    t.string "billing_type"
    t.string "external_id"
    t.integer "installment"
    t.decimal "value", precision: 10
    t.string "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "licenses", "customers"
  add_foreign_key "licenses", "payments"
end
