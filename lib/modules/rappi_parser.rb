module RappiParser
  def self.schedule(schedule_array)
    days = %i(monday tuesday wednesday thursday friday saturday sunday)
    schedule_hash = {}
    days.each do |day|
      times = schedule_array.find do |d| 
        d['day'] == day[0..2]
      end
      open = times ? times['open_time'] : ''
      close = times ? times['close_time'] : ''
      schedule_hash[day] = [open, close]
    end
    schedule_hash
  end
end
