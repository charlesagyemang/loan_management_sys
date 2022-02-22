# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_22_053824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "investors_id"
    t.decimal "principal"
    t.date "period_start"
    t.date "period_end"
    t.decimal "interest"
    t.decimal "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["investors_id"], name: "index_contributions_on_investors_id"
  end

  create_table "investors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "position"
    t.text "details"
    t.string "occupation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "loan_payments", force: :cascade do |t|
    t.bigint "loaner_id", null: false
    t.bigint "loan_id", null: false
    t.string "mode"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "next_payment_date"
    t.integer "amount"
    t.index ["loan_id"], name: "index_loan_payments_on_loan_id"
    t.index ["loaner_id"], name: "index_loan_payments_on_loaner_id"
  end

  create_table "loaners", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.string "occupation"
    t.string "id_type"
    t.string "id_number"
    t.text "address"
    t.boolean "is_verified"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "loans", force: :cascade do |t|
    t.decimal "principal"
    t.date "date_payment_starts"
    t.date "date_loan_given"
    t.decimal "interest_on_loan_per_month"
    t.integer "loan_period_in_months"
    t.string "payment_cadence"
    t.string "payment_day"
    t.bigint "loaner_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "amount"
    t.index ["loaner_id"], name: "index_loans_on_loaner_id"
  end

  create_table "payouts", force: :cascade do |t|
    t.bigint "investor_id", null: false
    t.bigint "contribution_id", null: false
    t.decimal "amount"
    t.date "date"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contribution_id"], name: "index_payouts_on_contribution_id"
    t.index ["investor_id"], name: "index_payouts_on_investor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "loan_payments", "loaners"
  add_foreign_key "loan_payments", "loans"
  add_foreign_key "loans", "loaners"
  add_foreign_key "payouts", "contributions"
  add_foreign_key "payouts", "investors"
end
