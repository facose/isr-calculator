require_relative '../test_helper'

class ProjectedAdjustmentTest < Minitest::Test
  def setup
    @adjustment = ProjectedAdjustment.new
  end

  def test_calculate_isr_with_projection_and_final_adjustment
    employee = Employee.new(name: "Test User", adjustment_type: :projected_adjustment)

    # Data based on the example in the exercise (4 weeks, varying days and salaries)
    weeks_data = [
      { number: 1, salary: 5000, days_worked: 4 },
      { number: 2, salary: 10000, days_worked: 7 },
      { number: 3, salary: 3850, days_worked: 3 },
      { number: 4, salary: 4500, days_worked: 6 }
    ]

    weeks_data.each do |w|
      employee.add_week(Week.new(number: w[:number], salary: w[:salary], days_worked: w[:days_worked]))
    end

    results = @adjustment.calculate_isr(employee)

    # Check the results array length
    assert_equal weeks_data.size, results.size

    # Extract ISR values for further checks
    isrs = results.map { |r| r[:isr] }

    # Last week ISR should equal monthly ISR for total income minus sum of previous ISRs
    monthly_table = ISRTable.new(:monthly)
    total_income = weeks_data.sum { |w| w[:salary] }
    expected_monthly_isr = monthly_table.calculate_isr(total_income)

    sum_previous_isrs = isrs[0..-2].sum
    expected_last_isr = (expected_monthly_isr - sum_previous_isrs).round(2)

    assert_in_delta expected_last_isr, isrs.last, 0.05

    # Check that week numbers and salaries match input
    results.each_with_index do |res, idx|
      assert_equal weeks_data[idx][:number], res[:week]
      assert_equal weeks_data[idx][:salary], res[:salary]
    end
  end
end
