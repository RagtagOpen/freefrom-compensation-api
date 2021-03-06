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

ActiveRecord::Schema.define(version: 2019_12_17_001558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mindsets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "resource_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["resource_category_id"], name: "index_mindsets_on_resource_category_id"
    t.index ["slug"], name: "index_mindsets_on_slug", unique: true
  end

  create_table "mindsets_quiz_responses", id: false, force: :cascade do |t|
    t.bigint "quiz_response_id", null: false
    t.bigint "mindset_id", null: false
    t.index ["quiz_response_id", "mindset_id"], name: "quiz_mindset_index"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_responses", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "quiz_question_id"
    t.index ["quiz_question_id"], name: "index_quiz_responses_on_quiz_question_id"
  end

  create_table "resource_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_resource_categories_on_slug", unique: true
  end

  create_table "resources", force: :cascade do |t|
    t.string "state"
    t.text "time"
    t.text "cost"
    t.text "award"
    t.text "likelihood"
    t.text "safety"
    t.text "story"
    t.bigint "resource_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "who"
    t.text "when"
    t.text "covered_expenses"
    t.text "attorney"
    t.text "tips", default: [], array: true
    t.text "where"
    t.text "resources", default: [], array: true
    t.text "steps", default: [], array: true
    t.text "challenges", default: [], array: true
    t.text "what_to_expect", default: [], array: true
    t.text "what_if_i_disagree", default: [], array: true
    t.index ["resource_category_id", "state"], name: "index_resources_on_resource_category_id_and_state", unique: true
    t.index ["resource_category_id"], name: "index_resources_on_resource_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
