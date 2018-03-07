require 'test/unit'
require_relative '../models/holiday_manager.rb'

# Class used for testing the month class.
class TestHolidays < Test::Unit::TestCase
  def test_holiday_takes_date_object
    holiday = Holiday.new('Christmas', Date.new(2018, 12, 25))
    assert_equal 'Christmas - December 25', holiday.to_s
  end

  def test_holiday_throws_on_improper_formatted_date
    assert_raise(ArgumentError) do
      Holiday.new('Christmas', 'asd')
    end
  end

  def test_holiday_takes_date_string_short
    holiday = Holiday.new('Christmas', '12-25')
    assert_equal 'Christmas - December 25', holiday.to_s
  end

  def test_holiday_takes_date_string_short_single_digits
    holiday = Holiday.new('Easter', '4-2')
    assert_equal 'Easter - April 2', holiday.to_s
  end

  def test_holiday_takes_date_string_long
    holiday = Holiday.new('Christmas', '12-25-2018')
    assert_equal 'Christmas - December 25', holiday.to_s
  end

  def test_holiday_manager_sorts_holidays
    hm = HolidayManager.new
    hm.add_holiday('Christmas', '12-25')
    hm.add_holiday('Easter', '4-2')
    assert_equal 'Christmas - December 25', hm.holidays[0].to_s
    hm.sort!
    assert_equal 'Easter - April 2', hm.holidays[0].to_s
  end
end
