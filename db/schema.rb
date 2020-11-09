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

ActiveRecord::Schema.define(version: 2020_11_08_191535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.integer "carbs_per_kilo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "meal_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_likes_on_meal_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "meal_categories", force: :cascade do |t|
    t.bigint "meal_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_meal_categories_on_category_id"
    t.index ["meal_id"], name: "index_meal_categories_on_meal_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "description"
    t.boolean "is_kosher", default: false
    t.boolean "is_vegetarian", default: false
    t.boolean "is_vegan", default: false
    t.boolean "is_halal", default: false
    t.integer "price_cents"
    t.integer "preparation_time"
    t.boolean "is_beverage", default: false
    t.float "popularity", default: 0.0
    t.bigint "restaurant_id"
    t.integer "number_of_ratings", default: 0
    t.integer "rating", default: 0
    t.integer "quantity", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_meals_on_restaurant_id"
  end

  create_table "portions", force: :cascade do |t|
    t.bigint "ingredient_id"
    t.bigint "meal_id"
    t.float "grams"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_portions_on_ingredient_id"
    t.index ["meal_id"], name: "index_portions_on_meal_id"
  end

  create_table "restaurant_categories", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_restaurant_categories_on_category_id"
    t.index ["restaurant_id"], name: "index_restaurant_categories_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.json "schedule"
    t.integer "popularity"
    t.string "logotype"
    t.integer "store_type"
    t.string "image"
    t.string "name"
    t.string "address"
    t.string "description"
    t.boolean "has_delivery", default: false
    t.integer "number_of_ratings", default: 0
    t.integer "rating", default: 0
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "friendly_schedule"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gender"
    t.integer "age"
    t.integer "profile"
    t.boolean "is_recurrent", default: false
    t.float "search_radius", default: 1.0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "likes", "meals"
  add_foreign_key "likes", "users"
  add_foreign_key "meal_categories", "categories"
  add_foreign_key "meal_categories", "meals"
  add_foreign_key "meals", "restaurants"
  add_foreign_key "portions", "ingredients"
  add_foreign_key "portions", "meals"
  add_foreign_key "restaurant_categories", "categories"
  add_foreign_key "restaurant_categories", "restaurants"
end
