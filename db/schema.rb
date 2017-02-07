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

ActiveRecord::Schema.define(version: 20170204004604) do

  create_table "annotations", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "min_tenure"
    t.integer  "max_tenure",      default: 216
    t.string   "skills"
    t.string   "optional_skills"
    t.string   "education_level"
    t.string   "degree_major"
    t.string   "work_area"
    t.string   "work_type"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "user",            default: "sovereign"
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.string   "company_name"
    t.string   "job_id"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
