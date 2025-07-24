require_relative '../test_helper'

# Dummy strategy classes to isolate Employee tests
class DummyStrategy
  def initialize(value)
    @value = value
  end

  def calculate_isr(employee)
    [{ week: 1, isr: @value }]
  end
end

class EmployeeTest < Minitest::Test
  def test_initialization
    employee = Employee.new(name: "Alice", adjustment_type: :no_adjustment)
    assert_equal "Alice", employee.name
    assert_equal :no_adjustment, employee.adjustment_type
    assert_empty employee.weeks
  end

  def test_add_week
    employee = Employee.new(name: "Bob", adjustment_type: :basic_adjustment)
    week = Week.new(number: 1, salary: 1000, days_worked: 7)
    employee.add_week(week)

    assert_equal 1, employee.weeks.size
    assert_equal week, employee.weeks.first
  end

  def test_calculate_isr_uses_correct_strategy
    employee_no = Employee.new(name: "Eve", adjustment_type: :no_adjustment)
    employee_no.define_singleton_method(:strategy) { DummyStrategy.new(111) }
    result_no = employee_no.calculate_isr
    assert_equal 111, result_no.first[:isr]

    employee_basic = Employee.new(name: "Eve", adjustment_type: :basic_adjustment)
    employee_basic.define_singleton_method(:strategy) { DummyStrategy.new(222) }
    result_basic = employee_basic.calculate_isr
    assert_equal 222, result_basic.first[:isr]

    employee_projected = Employee.new(name: "Eve", adjustment_type: :projected_adjustment)
    employee_projected.define_singleton_method(:strategy) { DummyStrategy.new(333) }
    result_projected = employee_projected.calculate_isr
    assert_equal 333, result_projected.first[:isr]
  end

  def test_calculate_isr_raises_error_for_unknown_adjustment_type
    employee = Employee.new(name: "Zed", adjustment_type: :unknown)

    error = assert_raises RuntimeError do
      employee.calculate_isr
    end
    assert_match(/Unknown adjustment type/, error.message)
  end
end
