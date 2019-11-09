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

ActiveRecord::Schema.define(version: 2019_11_09_230144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mindsets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "resource_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_category_id"], name: "index_mindsets_on_resource_category_id"
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
    t.text "short_description"
    t.text "description"
    t.binary "icon"
    t.string "seo_title"
    t.text "seo_description"
    t.string "seo_keywords", default: [], array: true
    t.binary "share_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "state"
    t.text "time"
    t.text "cost"
    t.text "award"
    t.text "likelihood"
    t.text "safety"
    t.text "story"
    t.text "challenges"
    t.bigint "resource_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "who"
    t.text "when"
    t.text "covered_expenses"
    t.text "attorney"
    t.text "tips", default: [], array: true
    t.text "where"
    t.text "what_to_expect"
    t.text "what_if_i_disagree"
    t.text "resources", default: [], array: true
    t.text "steps", default: [], array: true
    t.index ["resource_category_id", "state"], name: "index_resources_on_resource_category_id_and_state", unique: true
    t.index ["resource_category_id"], name: "index_resources_on_resource_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "role", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

end
