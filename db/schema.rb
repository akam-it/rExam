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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130419101328) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "title"
    t.boolean  "is_correct"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answers", ["is_correct"], :name => "index_answers_on_is_correct"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "exams", :force => true do |t|
    t.integer  "category_id"
    t.string   "title"
    t.string   "number"
    t.integer  "pass_score"
    t.integer  "time_limit"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "exams", ["category_id"], :name => "index_exams_on_category_id"

  create_table "questions", :force => true do |t|
    t.integer  "type_id"
    t.integer  "exam_id"
    t.integer  "section_id"
    t.string   "title"
    t.integer  "difficult"
    t.boolean  "allow_mix"
    t.string   "explanation"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "questions", ["exam_id"], :name => "index_questions_on_exam_id"
  add_index "questions", ["section_id"], :name => "index_questions_on_section_id"
  add_index "questions", ["type_id"], :name => "index_questions_on_type_id"

  create_table "sections", :force => true do |t|
    t.integer  "exam_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sections", ["exam_id"], :name => "index_sections_on_exam_id"

  create_table "types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
