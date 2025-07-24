require_relative '../test_helper'

class BasicAdjustmentTest < Minitest::Test
  def setup
    @adjustment = BasicAdjustment.new
  end

  def test_calculate_isr_for_multiple_weeks
    employee = Employee.new(name: "Test User", adjustment_type: :basic_adjustment)

    # Example weeks (from your provided exercise example)
    weeks_data = [
      { number: 1, salary: 10_000 },
      { number: 2, salary: 3_000 },
      { number: 3, salary: 7_000 },
      { number: 4, salary: 5_000 },
      { number: 5, salary: 5_000 }
    ]

    weeks_data.each do |w|
      employee.add_week(Week.new(number: w[:number], salary: w[:salary]))
    end

    results = @adjustment.calculate_isr(employee)

    # Sum of ISRs for first 4 weeks (rounded)
    accumulated_isr_first_4 = results[0..3].sum { |r| r[:isr] }

    # Expected monthly ISR for total income 30,000 (sum of salaries)
    monthly_table = ISRTable.new(:monthly)
    expected_monthly_isr = monthly_table.calculate_isr(30_000).round(2)

    # Last week ISR should be monthly ISR - accumulated ISRs of previous weeks
    expected_last_week_isr = (expected_monthly_isr - accumulated_isr_first_4).round(2)

    # Assertions:

    # Ensure last week ISR matches expected correction
    assert_in_delta expected_last_week_isr, results.last[:isr], 0.01

    # Ensure all weeks have correct week numbers and salaries
    results.each_with_index do |res, idx|
      assert_equal weeks_data[idx][:number], res[:week]
      assert_equal weeks_data[idx][:salary], res[:salary]
    end
  end
end
