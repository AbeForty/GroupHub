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

ActiveRecord::Schema.define(version: 20220525065717) do

  create_table "attachments", force: :cascade do |t|
    t.string   "attachment"
    t.integer  "task_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attachments", ["comment_id"], name: "index_attachments_on_comment_id"
  add_index "attachments", ["task_id"], name: "index_attachments_on_task_id"

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.string   "comment"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "comment_id"
  end

  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id"
  add_index "comments", ["task_id"], name: "index_comments_on_task_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "companycodes", force: :cascade do |t|
    t.string   "code"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "organizations_id"
  end

  add_index "companycodes", ["organizations_id"], name: "index_companycodes_on_organizations_id"

  create_table "ideas", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ideas", ["project_id"], name: "index_ideas_on_project_id"
  add_index "ideas", ["user_id"], name: "index_ideas_on_user_id"

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "members", ["project_id"], name: "index_members_on_project_id"
  add_index "members", ["user_id"], name: "index_members_on_user_id"

  create_table "milestones", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "duedate"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "status"
  end

  add_index "milestones", ["project_id"], name: "index_milestones_on_project_id"

  create_table "organization_email_users", force: :cascade do |t|
    t.integer  "Organization_id"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organization_email_users", ["Organization_id"], name: "index_organization_email_users_on_Organization_id"

  create_table "organization_project_email_users", force: :cascade do |t|
    t.integer  "Organization_id"
    t.integer  "Project_id"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organization_project_email_users", ["Organization_id"], name: "index_organization_project_email_users_on_Organization_id"
  add_index "organization_project_email_users", ["Project_id"], name: "index_organization_project_email_users_on_Project_id"

  create_table "organization_projects", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "project_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organization_projects", ["organization_id"], name: "index_organization_projects_on_organization_id"
  add_index "organization_projects", ["project_id"], name: "index_organization_projects_on_project_id"

  create_table "organization_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organization_users", ["organization_id"], name: "index_organization_users_on_organization_id"
  add_index "organization_users", ["user_id"], name: "index_organization_users_on_user_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "logo"
    t.string   "headercolor"
    t.string   "headertextcolor"
    t.string   "bodytextcolor"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "users_id"
  end

  add_index "organizations", ["users_id"], name: "index_organizations_on_users_id"

  create_table "priority_types", force: :cascade do |t|
    t.string   "title"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "priority_types", ["project_id"], name: "index_priority_types_on_project_id"

  create_table "project_types", force: :cascade do |t|
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "visibility_flags_id"
    t.date     "duedate"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id"
  add_index "projects", ["visibility_flags_id"], name: "index_projects_on_visibility_flags_id"

  create_table "status_types", force: :cascade do |t|
    t.string   "title"
    t.string   "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
  end

  add_index "status_types", ["project_id"], name: "index_status_types_on_project_id"

  create_table "tag_tasks", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tag_tasks", ["tag_id"], name: "index_tag_tasks_on_tag_id"
  add_index "tag_tasks", ["task_id"], name: "index_tag_tasks_on_task_id"

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
  end

  add_index "tags", ["project_id"], name: "index_tags_on_project_id"

  create_table "tags_tasks", id: false, force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "tag_id",  null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "status"
    t.date     "duedate"
    t.integer  "project_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "milestone_id"
    t.integer  "PriorityType_id"
  end

  add_index "tasks", ["PriorityType_id"], name: "index_tasks_on_PriorityType_id"
  add_index "tasks", ["milestone_id"], name: "index_tasks_on_milestone_id"
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "user_types", force: :cascade do |t|
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "hideEmail"
  end

  create_table "visibility_flags", force: :cascade do |t|
    t.string   "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "waitinglists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "waitinglists", ["project_id"], name: "index_waitinglists_on_project_id"
  add_index "waitinglists", ["user_id"], name: "index_waitinglists_on_user_id"

end
