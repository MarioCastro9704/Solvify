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

ActiveRecord::Schema[7.1].define(version: 2024_06_27_043053) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.bigint "psychologist_id", null: false
    t.date "business_date"
    t.time "starting_hour"
    t.time "ending_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psychologist_id"], name: "index_availabilities_on_psychologist_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "psychologist_id", null: false
    t.date "date"
    t.time "time"
    t.string "link_to_meet"
    t.string "payment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_time"
    t.index ["psychologist_id"], name: "index_bookings_on_psychologist_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "psychologists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "specialty"
    t.string "degree"
    t.string "document_of_identity"
    t.boolean "availability"
    t.integer "years_of_experience"
    t.text "description"
    t.float "average_rating"
    t.decimal "price_per_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "specialties"
    t.string "approach"
    t.string "languages"
    t.string "nationality"
    t.decimal "price_per_session"
    t.index ["user_id"], name: "index_psychologists_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comments"
    t.integer "ratings"
    t.bigint "psychologist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psychologist_id"], name: "index_reviews_on_psychologist_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.decimal "price_per_session"
    t.text "specialties"
    t.boolean "published"
    t.bigint "psychologist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psychologist_id"], name: "index_services_on_psychologist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "gender"
    t.string "address"
    t.string "nationality"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "availabilities", "psychologists"
  add_foreign_key "bookings", "psychologists"
  add_foreign_key "bookings", "users"
  add_foreign_key "psychologists", "users"
  add_foreign_key "reviews", "psychologists"
  add_foreign_key "services", "psychologists"
end
