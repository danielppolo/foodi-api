require 'httparty'
require 'colorize'
require 'active_support/inflections'

CONJUNCIONES = %w[
  y
  e
  ni
  que
  o
  u
  bien
  pero
  para
  mas
  salvo
  sino
  aunque
  ya
  bien
].freeze

BEBIDAS = %w[
  nestea
  coca
  sprite
  cola
  fanta
  boing
  pepsi
  delaware
  sidral
  mundet
  manzanita
  jamaica
  horchata
  agua
  zero
  milk
  jarritos
  topo chico
  boing
  refresco
  jugo
  peñafiel
  mineral
  limonada
  naranjada
  malteada
  mirinda
  bebida
  licuado
  smoothie
  fresca
  light
  ciel
  natural
  lata
  embotellada
  botella
  drink
].freeze

UNITS = %w[
  ml
  lt
  litro
  oz
].freeze

BEER = %w[
  cerveza
  corona
  victoria
  ultra
  beer
].freeze

COFFEE = %w[
  capucino
  moka
  capuccino
  frapuccino
  frapucino
  frappe
  cafe
  café
  latte
  chai
  espresso
].freeze

BLACKLIST = %w[
  whoper
  whopper
  recomenda
  paquete
  combo
  sencillo
  doble
  especial
  acompaña
  original
  suprema
  mc
  promo
  compartir
  persona
  carta
  cuarto
  deluxe
  club
  super
  pequeñ
  median
  grande
  rappi
  familiar
  frio
  frío
  caliente
  blanco
  nuestro
  nuestra
  naranjito
  orden
].freeze

module RappiServices
  class Parser
    def parse(data)
      restaurant = parse_restaurant(data)
      parse_meals(data, restaurant) if restaurant
    rescue StandardError => e
      puts e.to_s.red
    end

    private

    def parse_restaurant(restaurant)
      puts restaurant[:name]
      restaurant = Restaurant.create!(
        name: restaurant[:name],
        external_image_url: restaurant[:background] && "https://images.rappi.com.mx/restaurants_background/#{restaurant[:background]}",
        external_logo_url: restaurant[:logo] && "https://images.rappi.com.mx/restaurants_logo/#{restaurant[:logo]}",
        address: restaurant[:address],
        rating: restaurant[:rating] && restaurant[:rating][:score],
        number_of_ratings: restaurant[:rating] && restaurant[:rating][:total_reviews],
        has_delivery: restaurant[:delivery_methods]&.include?('delivery') || true,
        latitude: restaurant[:location] && restaurant[:location][1],
        longitude: restaurant[:location] && restaurant[:location][0],
        friendly_schedule: parse_schedules(restaurant[:schedules]),
        provider: 'rappi',
        external_id: restaurant[:store_id],
        external_url: build_url(store_id: restaurant[:store_id])
      )
      assign_categories(restaurant: restaurant, categories: parse_categories(restaurant[:tags]))
      restaurant
    end

    def parse_categories(list)
      return unless list

      list.map do |category|
        name = remove_accents(category[:name].downcase.strip)
        name = name.singularize(:es)
        Category.find_or_create_by(name: name)
      end
    end

    def parse_meals(data, restaurant)
      data[:corridors].each do |group|
        group[:products].each do |meal|
          next if !meal[:image] || meal[:image] == 'NO-IMAGE' || meal[:image] == ''

          puts "> #{meal[:name]}"
          meal_instance = Meal.create!(
            name: meal[:name],
            external_image_url: "https://images.rappi.com.mx/products/#{meal[:image]}",
            description: meal[:description],
            price: meal[:price],
            quantity: meal[:quantity],
            preparation_time: data[:saturation][:cooking_time],
            restaurant: restaurant,
            latitude: restaurant.latitude,
            longitude: restaurant.longitude,
            provider: 'rappi',
            external_id: restaurant[:id],
            external_url: build_url(meal_id: meal[:id], store_id: meal[:store_id]),
            is_beverage: beverage?(meal[:name].strip.downcase) || beverage?(group[:name].strip.downcase)
          )
          assign_categories(
            meal: meal_instance,
            categories: generate_categories(name: meal_instance.name, category: group[:name])
          )
        end
      end
    end

    def generate_categories(name: '', category: '')
      words = "#{name.strip} #{category.strip}".downcase.split(' ')
      whitelist_tags(words).map do |word|
        Category.find_or_create_by(name: word)
      end
    end

    def assign_categories(restaurant: nil, categories: nil, meal: nil)
      return unless categories

      categories.each do |category|
        puts "  `#{category.name}`".yellow
        RestaurantCategory.create!(restaurant: restaurant, category: category) if restaurant
        MealCategory.create!(meal: meal, category: category) if meal
      end
    end

    def parse_schedules(schedules)
      week_schedule = {}
      day_schedule = []
      schedules.each do |schedule|
        day_schedule << [schedule[:open_time], schedule[:close_time]]
      end
      Date::DAYNAMES.each do |day|
        week_schedule[day.downcase] = day_schedule
      end
      week_schedule
    end

    def remove_accents(word)
      return '' unless word

      word.gsub(/á/, 'a').gsub(/é/, 'e').gsub(/í/, 'i').gsub(/ó/, 'o').gsub(/ú/, 'u')
    end

    def remove_special_chars(word)
      return '' unless word

      word.gsub(/[^a-zA-ZñÑáéíóúÁÉÍÓÚ]/, '').gsub(/\d/, '')
    end

    def normalize_word(word)
      return '' unless word

      normal_word = remove_special_chars(word)
      normal_word = remove_accents(normal_word)
      normal_word.singularize(:es)
    end

    def whitelist_tags(words)
      normalized_words = words.map { |word| normalize_word(word) }
      filtered_words = normalized_words.select do |word|
        word.length > 3 &&
          !CONJUNCIONES.include?(word) &&
          BLACKLIST.none? { |blackword| word.include? blackword } &&
          !beverage?(word)
      end
      filtered_words.uniq
    end

    def beverage?(word)
      drink?(word) ||
        coffee?(word) ||
        beer?(word) ||
        liquid_unit?(word)
    end

    def drink?(word)
      BEBIDAS.any? { |drink| word.include? drink }
    end

    def coffee?(word)
      COFFEE.any? { |drink| word.include? drink }
    end

    def beer?(word)
      BEER.any? { |drink| word.include? drink }
    end

    def liquid_unit?(word)
      UNITS.any? { |drink| word.strip == drink }
    end

    def build_url(meal_id: nil, store_id: nil)
      return '' unless meal_id || store_id

      return "https://www.rappi.com.mx/restaurantes/#{store_id}/product/#{meal_id}" if meal_id && store_id
      return "https://www.rappi.com.mx/restaurantes/#{store_id}" if store_id
    end
  end
end
