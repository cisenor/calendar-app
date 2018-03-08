require 'date'

# Defines a month object
class Month
  attr_reader :year
  attr_reader :name
  attr_reader :last_day
  attr_reader :start_day
  attr_reader :weeks
  attr_reader :month
  def initialize(year, month)
    @year = year
    @month = month
    d = Date.civil(@year, @month, -1)
    @last_day = d.day
    @start_day = 1
    @name = Date::MONTHNAMES[@month]
    create_weeks
  end

  def create_weeks
    @weeks = []
    days = (@start_day..@last_day).to_a
    @weeks << create_first_week(days)
    until days.empty?
      week = []
      7.times do
        week << days.shift
      end
      @weeks << week
    end
  end

  def create_first_week(days)
    week_start = Date.new(@year, @month, days.first).wday
    (0..6).map do |day|
      days.shift if day >= week_start
    end
  end

  def week(week_num)
    @weeks[week_num]
  end

  def nth_weekday_of_month(nth, weekday)
    index = 1
    weeks.each do |week|
      next if week[weekday].nil?
      return week[weekday] if index == nth
      index += 1
    end
    nil
  end

  # Whether the provided day is valid for this month
  def valid_day?(day)
    day.to_i <= @last_day && day.to_i >= 1
  end

  def to_s
    @name
  end
  private :create_weeks, :create_first_week
end
