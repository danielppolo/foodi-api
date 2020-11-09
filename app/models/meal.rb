class Meal < ApplicationRecord
  after_create { Meal.set_categories }

  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true
  validates :image, presence: true
  validates :restaurant, presence: true
  validates :preparation_time,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
  # validates :has_delivery, presence: true

  belongs_to :restaurant
  has_many :portions
  has_many :ingredients, through: :portions
  has_many :restaurant_categories, through: :restaurant
  has_many :meal_categories, dependent: :destroy
  has_many :categories, through: :meal_categories
  has_one_attached :image

  monetize :price_cents,
           allow_nil: true,
           numericality: {
             greater_than_or_equal_to: 0,
             less_than_or_equal_to: 10_000
           }

  COMMON_WORDS = Hash.new(0)

  def open?
    restaurant.open?
  end

  alias available? open?

  def delivery?
    restaurant.delivery
  end

  def self.categories
    COMMON_WORDS.sort_by { |_key, value| value }
                .map { |a| a[0] }
                .reverse
  end

  def self.set_categories
    Meal.all.each do |meal|
      meal.name.split(' ').each do |word|
        COMMON_WORDS[word] += 1 if word.length > 3
      end
    end
  end

  def self.nearby_categories(limit:, cookies:, radius:)
    # TODO:
    # categories = []
    # Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], search_radius).each do |restaurant|
    #   restaurant.meals.each do |meal|
    #     meal.category.split(" ").each do |category|
    #       categories << category if category.length > 3
    #     end
    #   end
    # end
    # counts = Hash.new(0)
    # categories.each { |word| counts[word] += 1 }
    # counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(limit)
  end

  def self.filter_by_location(latitude:, longitude:, radius:)
    nearby_restaurants = Restaurant.filter_by_location(
      latitude: latitude,
      longitude: longitude,
      radius: radius
    )
    nearby_restaurants.map(&:meals).flatten
  end

  def self.filter_by_cuisine
    # TODO:
    # Meal.where()
  end

  def self.filter_by_price
    # TODO:
    # Meal.where()
  end

  def self.filter_by_restaurant
    # TODO:
    restaurant.meals
  end

  def self.filter_by_time
    # TODO:
    # Meal.where()
  end
end

# def available?
#   self.restaurant.open?
# end

# def self.filter(params, cookies, search_radius) # => Returns array of Display Meals
#   # available = by_location(cookies, search_radius)
#   # available = by_time(by_location(cookies, search_radius))
#   available = Meal.all
#   available = by_price(available, params) if params[:max_price]
#   # available = by_category(available, params) if params[:category]
#   available = randomize(available) if params[:randomize]
#   available
# end

# def self.by_time(meal_list)
#   # => Returns an array of OpenNow Meals
#   meal_list.select do |meal|
#     meal.available?
#   end
# end

# def self.randomize(meal_list)
#   meal_list.shuffle
# end

# def self.by_price(meal_list, params)
#   meal_list.select do |m|
#     m.price.to_i.between?(0, params[:max_price].to_i)
#   end
# end
# # # BY RESTAURANT
# # def self.by_category(meal_list, params)
# #   meal_list.select do |m|
# #     m.restaurant.category.include?(params[:category])
# #   end
# # end

# # BY MEAL
# def self.by_category(meal_list, params)
#   meal_list.select do |m|
#     m.category.downcase.include?(params[:category])
#   end
# end

# def self.by_other(meal_list, params)
#   meal_list.select do |m|
#     m.description.include?(params[:category])
#   end
# end

# # BY MEAL CATEGORY
#   def self.categories(number_of_results)
#     words = []
#     Meal.all.each {|m| m.category.split(' ').each { |w| words <<  w if w.length > 3 } }
#     counts = Hash.new(0)
#     words.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

#   def self.nearby_categories(number_of_results, cookies, search_radius)
#     categories = []
#     Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], search_radius).each do |restaurant|
#       restaurant.meals.each do |meal|
#         meal.category.split(" ").each do |category|
#           categories << category if category.length > 3
#         end
#       end
#     end
#     counts = Hash.new(0)
#     categories.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end
# end

# # BY RESTAURANT CATEGORIES
#   def self.categories(number_of_results)
#     categories = []
#     Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
#     counts = Hash.new(0)
#     categories.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

#   def self.nearby_categories(number_of_results, cookies, search_radius)
#     categories = []
#     Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], search_radius).each do |r|
#       r.category.split(",").each { |c| categories << c }
#     end
#     counts = Hash.new(0)
#     categories.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

# # BY MEAL NAME
#   def self.categories(number_of_results)
#     words = []
#     Meal.all.each {|m| m.name.split(" ").each { |w| words <<  w if w.length > 3 } }
#     counts = Hash.new(0)
#     words.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

#   def self.nearby_categories(number_of_results, cookies, search_radius)
#   end

# # BY MEAL DESCRIPTION
#   def self.categories(number_of_results)
#     categories = []
#     Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
#     counts = Hash.new(0)
#     categories.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end
