module Types 
  class PriceType < BaseScalar
    description "Formatted price."
  
    def self.coerce_input(input_value, context)
      money.format
      99
    end
  
    def self.coerce_result(ruby_value, context)
      # It's transported as a string, so stringify it
      ruby_value.to_s
    end
  end
end


# app/graphql/types/url.rb
