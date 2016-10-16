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

ActiveRecord::Schema.define(version: 20161010100238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "certificates", force: :cascade do |t|
    t.string   "title"
    t.date     "issue_date"
    t.string   "issuing_institution"
    t.string   "description"
    t.integer  "worker_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "comfy_cms_blocks", force: :cascade do |t|
    t.string   "identifier",     null: false
    t.text     "content"
    t.integer  "blockable_id"
    t.string   "blockable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_blocks", ["blockable_id", "blockable_type"], name: "index_comfy_cms_blocks_on_blockable_id_and_blockable_type", using: :btree
  add_index "comfy_cms_blocks", ["identifier"], name: "index_comfy_cms_blocks_on_identifier", using: :btree

  create_table "comfy_cms_categories", force: :cascade do |t|
    t.integer "site_id",          null: false
    t.string  "label",            null: false
    t.string  "categorized_type", null: false
  end

  add_index "comfy_cms_categories", ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true, using: :btree

  create_table "comfy_cms_categorizations", force: :cascade do |t|
    t.integer "category_id",      null: false
    t.string  "categorized_type", null: false
    t.integer "categorized_id",   null: false
  end

  add_index "comfy_cms_categorizations", ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree

  create_table "comfy_cms_files", force: :cascade do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "block_id"
    t.string   "label",                                      null: false
    t.string   "file_file_name",                             null: false
    t.string   "file_content_type",                          null: false
    t.integer  "file_file_size",                             null: false
    t.string   "description",       limit: 2048
    t.integer  "position",                       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_files", ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id", using: :btree
  add_index "comfy_cms_files", ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name", using: :btree
  add_index "comfy_cms_files", ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label", using: :btree
  add_index "comfy_cms_files", ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position", using: :btree

  create_table "comfy_cms_layouts", force: :cascade do |t|
    t.integer  "site_id",                    null: false
    t.integer  "parent_id"
    t.string   "app_layout"
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.text     "css"
    t.text     "js"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_layouts", ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_layouts", ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree

  create_table "comfy_cms_pages", force: :cascade do |t|
    t.integer  "site_id",                        null: false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",                          null: false
    t.string   "slug"
    t.string   "full_path",                      null: false
    t.text     "content_cache"
    t.integer  "position",       default: 0,     null: false
    t.integer  "children_count", default: 0,     null: false
    t.boolean  "is_published",   default: true,  null: false
    t.boolean  "is_shared",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_pages", ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_pages", ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path", using: :btree

  create_table "comfy_cms_revisions", force: :cascade do |t|
    t.string   "record_type", null: false
    t.integer  "record_id",   null: false
    t.text     "data"
    t.datetime "created_at"
  end

  add_index "comfy_cms_revisions", ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at", using: :btree

  create_table "comfy_cms_sites", force: :cascade do |t|
    t.string  "label",                       null: false
    t.string  "identifier",                  null: false
    t.string  "hostname",                    null: false
    t.string  "path"
    t.string  "locale",      default: "en",  null: false
    t.boolean "is_mirrored", default: false, null: false
  end

  add_index "comfy_cms_sites", ["hostname"], name: "index_comfy_cms_sites_on_hostname", using: :btree
  add_index "comfy_cms_sites", ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored", using: :btree

  create_table "comfy_cms_snippets", force: :cascade do |t|
    t.integer  "site_id",                    null: false
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_snippets", ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
  add_index "comfy_cms_snippets", ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "educations", force: :cascade do |t|
    t.string   "school"
    t.string   "degree"
    t.string   "field_of_study"
    t.string   "description"
    t.integer  "worker_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "farmers", force: :cascade do |t|
    t.string   "email",                                 default: "",    null: false
    t.string   "encrypted_password",                    default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "first_name",                            default: "",    null: false
    t.string   "last_name",                             default: "",    null: false
    t.string   "referral_token"
    t.integer  "referral_user_id"
    t.string   "referral_user_type"
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_type"
    t.integer  "profile_photo_file_size"
    t.datetime "profile_photo_updated_at"
    t.integer  "location_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.string   "business_name"
    t.text     "business_description"
    t.string   "contact_name"
    t.string   "contact_number"
    t.string   "stripe_customer_id"
    t.boolean  "stripe_delinquent"
    t.integer  "credit",                                default: 0
    t.boolean  "migrated",                              default: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                     default: 0
    t.string   "authentication_token",       limit: 30
  end

  add_index "farmers", ["authentication_token"], name: "index_farmers_on_authentication_token", unique: true, using: :btree
  add_index "farmers", ["confirmation_token"], name: "index_farmers_on_confirmation_token", unique: true, using: :btree
  add_index "farmers", ["email"], name: "index_farmers_on_email", unique: true, using: :btree
  add_index "farmers", ["invitation_token"], name: "index_farmers_on_invitation_token", unique: true, using: :btree
  add_index "farmers", ["invitations_count"], name: "index_farmers_on_invitations_count", using: :btree
  add_index "farmers", ["invited_by_id"], name: "index_farmers_on_invited_by_id", using: :btree
  add_index "farmers", ["reset_password_token"], name: "index_farmers_on_reset_password_token", unique: true, using: :btree

  create_table "job_categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "job_categories_jobs", id: false, force: :cascade do |t|
    t.integer "job_id",          null: false
    t.integer "job_category_id", null: false
  end

  create_table "job_categories_skills", id: false, force: :cascade do |t|
    t.integer "job_category_id", null: false
    t.integer "skill_id",        null: false
  end

  add_index "job_categories_skills", ["job_category_id", "skill_id"], name: "index_job_categories_skills_on_job_category_id_and_skill_id", using: :btree
  add_index "job_categories_skills", ["skill_id", "job_category_id"], name: "index_job_categories_skills_on_skill_id_and_job_category_id", using: :btree

  create_table "job_categories_workers", id: false, force: :cascade do |t|
    t.integer "job_category_id", null: false
    t.integer "worker_id",       null: false
  end

  create_table "job_workers", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "worker_id"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "job_workers", ["job_id"], name: "index_job_workers_on_job_id", using: :btree
  add_index "job_workers", ["worker_id"], name: "index_job_workers_on_worker_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "farmer_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "accomodation_provided"
    t.string   "business_name"
    t.text     "business_description"
    t.integer  "location_id"
    t.string   "pay_min"
    t.string   "pay_max"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "number_of_workers"
    t.boolean  "published",             default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "live",                  default: true
  end

  add_index "jobs", ["farmer_id"], name: "index_jobs_on_farmer_id", using: :btree
  add_index "jobs", ["location_id"], name: "index_jobs_on_location_id", using: :btree

  create_table "jobs_skills", id: false, force: :cascade do |t|
    t.integer "job_id",   null: false
    t.integer "skill_id", null: false
  end

  create_table "jobs_workers", id: false, force: :cascade do |t|
    t.integer "job_id",    null: false
    t.integer "worker_id", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "state",      null: false
    t.string   "region",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations_workers", id: false, force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "worker_id",   null: false
  end

  add_index "locations_workers", ["location_id", "worker_id"], name: "index_locations_workers_on_location_id_and_worker_id", using: :btree
  add_index "locations_workers", ["worker_id", "location_id"], name: "index_locations_workers_on_worker_id_and_location_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "action_path",            default: "#"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "header",                 default: ""
    t.string   "description",            default: ""
    t.boolean  "unseen",                 default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "payment_audits", force: :cascade do |t|
    t.integer  "farmer_id"
    t.integer  "job_id"
    t.string   "action"
    t.string   "message"
    t.boolean  "success"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "amount",     default: 0
  end

  add_index "payment_audits", ["farmer_id"], name: "index_payment_audits_on_farmer_id", using: :btree
  add_index "payment_audits", ["job_id"], name: "index_payment_audits_on_job_id", using: :btree

  create_table "previous_employers", force: :cascade do |t|
    t.string   "business_name"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.integer  "worker_id"
    t.string   "job_title"
    t.string   "job_description"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "reviewee_id"
    t.string   "reviewee_type"
    t.integer  "reviewer_id"
    t.string   "reviewer_type"
    t.integer  "rating"
    t.string   "feedback"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills_workers", id: false, force: :cascade do |t|
    t.integer "skill_id",  null: false
    t.integer "worker_id", null: false
  end

  create_table "unavailabilities", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "worker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workers", force: :cascade do |t|
    t.string   "first_name",                            default: "",    null: false
    t.string   "last_name",                             default: "",    null: false
    t.boolean  "has_own_transport",                     default: false, null: false
    t.string   "referral_token"
    t.string   "tax_file_number"
    t.string   "mobile_number"
    t.string   "nationality"
    t.string   "email",                                 default: "",    null: false
    t.string   "encrypted_password",                    default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "referral_user_id"
    t.string   "referral_user_type"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_type"
    t.integer  "profile_photo_file_size"
    t.datetime "profile_photo_updated_at"
    t.date     "dob"
    t.boolean  "verified",                              default: false
    t.boolean  "migrated",                              default: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                     default: 0
    t.string   "description",                           default: ""
    t.string   "authentication_token",       limit: 30
  end

  add_index "workers", ["authentication_token"], name: "index_workers_on_authentication_token", unique: true, using: :btree
  add_index "workers", ["confirmation_token"], name: "index_workers_on_confirmation_token", unique: true, using: :btree
  add_index "workers", ["email"], name: "index_workers_on_email", unique: true, using: :btree
  add_index "workers", ["invitation_token"], name: "index_workers_on_invitation_token", unique: true, using: :btree
  add_index "workers", ["invitations_count"], name: "index_workers_on_invitations_count", using: :btree
  add_index "workers", ["invited_by_id"], name: "index_workers_on_invited_by_id", using: :btree
  add_index "workers", ["reset_password_token"], name: "index_workers_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "job_workers", "jobs"
  add_foreign_key "job_workers", "workers"
  add_foreign_key "jobs", "farmers"
  add_foreign_key "jobs", "locations"
  add_foreign_key "payment_audits", "farmers"
  add_foreign_key "payment_audits", "jobs"
end
