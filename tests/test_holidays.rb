require 'test/unit'
require_relative '../models/holiday_list.rb'

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

  def test_add_holiday_based_on_week
    holiday_list = HolidayList.new(Year.new(2018))
    holiday_list.create_holiday_based_on_week('Easter', 3, 1, 1)
    assert_equal 'Easter - April 2', holiday_list.holidays[0].to_s
    holiday_list.create_holiday_based_on_week('Thanksgiving', 9, 2, 1)
    assert_equal 'Thanksgiving - October 8', holiday_list.holidays[1].to_s
  end
end
