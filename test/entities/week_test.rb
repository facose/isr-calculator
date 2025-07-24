require_relative '../test_helper'

class WeekTest < Minitest::Test
  def test_initialize_with_defaults
    week = Week.new(number: 1, salary: 3000)
    
    assert_equal 1, week.number
    assert_equal 3000, week.salary
    assert_equal 7, week.days_worked  # default value
  end

  def test_initialize_with_days_worked
    week = Week.new(number: 2, salary: 2500, days_worked: 5)
    
    assert_equal 2, week.number
    assert_equal 2500, week.salary
    assert_equal 5, week.days_worked
  end
end
