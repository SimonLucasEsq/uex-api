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

ActiveRecord::Schema[7.0].define(version: 2023_06_28_071726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.string "address"
    t.boolean "virtual_participation"
    t.bigint "professor_id", null: false
    t.bigint "activity_type_id", null: false
    t.bigint "organizing_organization_id"
    t.bigint "partner_organization_id"
    t.string "project_link"
    t.integer "hours"
    t.integer "ods_vinculation"
    t.boolean "institutional_program"
    t.string "institutional_extension_line"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "evaluation"
    t.date "approved_at"
    t.string "resolution_number"
    t.index ["activity_type_id"], name: "index_activities_on_activity_type_id"
    t.index ["organizing_organization_id"], name: "index_activities_on_organizing_organization_id"
    t.index ["partner_organization_id"], name: "index_activities_on_partner_organization_id"
    t.index ["professor_id"], name: "index_activities_on_professor_id"
  end

  create_table "activity_careers", force: :cascade do |t|
    t.bigint "career_id", null: false
    t.bigint "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_careers_on_activity_id"
    t.index ["career_id"], name: "index_activity_careers_on_career_id"
  end

  create_table "activity_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activity_week_participants", force: :cascade do |t|
    t.integer "hours"
    t.string "evaluation"
    t.bigint "activity_week_id", null: false
    t.string "participable_type"
    t.bigint "participable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_week_id"], name: "index_activity_week_participants_on_activity_week_id"
    t.index ["participable_type", "participable_id"], name: "index_activity_week_participants_on_participable"
  end

  create_table "activity_weeks", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_weeks_on_activity_id"
  end

  create_table "beneficiary_details", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.integer "number_of_men"
    t.integer "number_of_women"
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_beneficiary_details_on_activity_id"
  end

  create_table "careers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.boolean "current_agreement"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phonenumber"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "id_card"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sex"
  end

  create_table "professor_careers", force: :cascade do |t|
    t.bigint "professor_id", null: false
    t.bigint "career_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_id"], name: "index_professor_careers_on_career_id"
    t.index ["professor_id"], name: "index_professor_careers_on_professor_id"
  end

  create_table "professors", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_professors_on_person_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.integer "hours", default: 0
    t.boolean "submitted"
    t.string "admission_year"
    t.bigint "career_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_id"], name: "index_students_on_career_id"
    t.index ["person_id"], name: "index_students_on_person_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "activities", "activity_types"
  add_foreign_key "activities", "organizations", column: "organizing_organization_id"
  add_foreign_key "activities", "organizations", column: "partner_organization_id"
  add_foreign_key "activities", "professors"
  add_foreign_key "activity_careers", "activities"
  add_foreign_key "activity_careers", "careers"
  add_foreign_key "activity_week_participants", "activity_weeks"
  add_foreign_key "activity_weeks", "activities"
  add_foreign_key "beneficiary_details", "activities"
  add_foreign_key "professor_careers", "careers"
  add_foreign_key "professor_careers", "professors"
  add_foreign_key "professors", "people"
  add_foreign_key "students", "careers"
  add_foreign_key "students", "people"
end
