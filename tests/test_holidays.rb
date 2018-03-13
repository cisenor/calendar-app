require 'test/unit'
require_relative '../models/important_date_store.rb'

# Class used for testing the month class.
class TestHolidays < Test::Unit::TestCase
  def test_holiday_throws_on_improper_formatted_date
    assert_raise(ArgumentError) do
      Holiday.new('Christmas', 'asd')
    end
  end

  def test_holiday_takes_date
    holiday = Holiday.new('Christmas', Date.new(2018, 12, 25), :holiday)
    assert_equal 'Christmas - December 25', holiday.to_s
  end

  def test_add_holiday_based_on_week
    important_dates = ImportantDateStore.new(Year.new(2018))
    important_dates.calculate_important_date('Easter', 3, 1, 1, :holiday)
    assert_equal 'Easter - April 2', important_dates.holidays[0].to_s

    important_dates.calculate_important_date('Thanksgiving', 9, 2, 1, :holiday)
    assert_equal 'Thanksgiving - October 8', important_dates.holidays[1].to_s
  end

  def test_is_holiday
    important_dates = ImportantDateStore.new(Year.new(2018))
    important_dates.mark_date('Remembrance Day', Date.new(2018, 11, 11), :holiday)
    assert_equal :holiday, important_dates.styling(Date.new(2018, 11, 11))
  end

  def test_is_not_holiday
    important_dates = ImportantDateStore.new(Year.new(2018))
    assert_equal :none, important_dates.styling(Date.new(2018, 12, 22))
  end

  def test_get_holiday_type
    important_dates = ImportantDateStore.new(Year.new(2000))
    important_dates.calculate_important_date('Easter', 3, 1, 1, :holiday)
    important_dates.calculate_important_date('Thanksgiving', 9, 2, 1, :holiday)
    important_dates.mark_date('Remembrance Day', Date.new(2000, 11, 11), :holiday)
    important_dates.mark_date('Christmas Day', Date.new(2000, 12, 25), :holiday)
    important_dates.mark_date('Leap Day', Date.new(2000, 2, 29), :leap)
    important_dates.mark_date('Friday the 13th', Date.new(2000, 10, 13), :friday13)
    assert_equal :leap, important_dates.styling(Date.new(2000, 2, 29))
    assert_equal :friday13, important_dates.styling(Date.new(2000, 10, 13))
    assert_equal :holiday, important_dates.styling(Date.new(2000, 12, 25))
    assert_equal :none, important_dates.styling(Date.new(2000, 1, 24))
  end
end
