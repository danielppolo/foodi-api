require 'date'

module Schedule
  SEP = '_'
  def self.to_string(
    monday:,
    tuesday:,
    wednesday:,
    thursday:,
    friday:,
    saturday:,
    sunday:
  )
    "#{monday[0]}-#{monday[1]}#{SEP}"\
      "#{tuesday[0]}-#{tuesday[1]}#{SEP}"\
      "#{wednesday[0]}-#{wednesday[1]}#{SEP}"\
      "#{thursday[0]}-#{thursday[1]}#{SEP}"\
      "#{friday[0]}-#{friday[1]}#{SEP}"\
      "#{saturday[0]}-#{saturday[1]}#{SEP}"\
      "#{sunday[0]}-#{sunday[1]}"
  end

  def self.parse(schedule)
    days = %i[monday tuesday wednesday thursday friday saturday sunday]
    schedule_array = schedule.split(SEP)
    schedule_hash = {}
    days.each_with_index do |day, index|
      schedule_hash[day] = schedule_array[index].split('-')
    end
    schedule_hash
  end

  def self.today(schedule)
    today = Date.today
    schedule.each do |day, hours|
      is_today = today.send("#{day}?".to_sym)
      if is_today
        return {
          open: hours[0],
          close: hours[1]
        }
      end
    end
  end

  def self.time(hour:, minute:)
    today = Date.today
    Time.new(
      today.year,
      today.month,
      today.day,
      hour,
      minute,
      0
    )
  end

  def self.parse_time(time)
    t = time.split(':')
    {
      hour: t[0].to_i,
      minute: t[1].to_i,
      second: t[2].to_i
    }
  end
end
