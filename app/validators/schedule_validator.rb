require 'date'

class ScheduleValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.instance_of?(Hash)
      record.errors[attribute] << (options[:message] || 'is not a Hash')
      return
    end

    missing_days = Date::DAYNAMES.map(&:downcase).sort - value.keys.sort
    unless missing_days.empty?
      record.errors[attribute] << (options[:message] || "is missing days: #{missing_days.join(', ')}")
    end

    # TODO: Validate time and array size.
  end
end
