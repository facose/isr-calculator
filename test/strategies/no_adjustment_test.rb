require_relative '../test_helper'

class NoAdjustmentTest < Minitest::Test
  def setup
    @adjustment = NoAdjustment.new
  end

  def test_calculate_isr_per_week_without_adjustment
    employee = Employee.new(name: "Test User", adjustment_type: :no_adjustment)

    weeks_data = [
      { number: 1, salary: 3000 },
      { number: 2, salary: 3500 },
      { number: 3, salary: 2800 }
    ]

    weeks_data.each do |w|
      employee.add_week(Week.new(number: w[:number], salary: w[:salary]))
    end

    results = @adjustment.calculate_isr(employee)

    assert_equal weeks_data.size, results.size

    results.each_with_index do |res, idx|
      assert_equal weeks_data[idx][:number], res[:week]
      assert_equal weeks_data[idx][:salary], res[:salary]
      
      # ISR should be calculated using the weekly ISR table
      expected_isr = ISRTable.new(:weekly).calculate_isr(res[:salary]).round(2)
      assert_in_delta expected_isr, res[:isr], 0.01
    end
  end
end
