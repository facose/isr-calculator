require_relative '../test_helper'

class ISRTableTest < Minitest::Test
  def test_initialize_with_valid_frequency
    table_monthly = ISRTable.new(:monthly)
    table_weekly = ISRTable.new(:weekly)

    assert_instance_of ISRTable, table_monthly
    assert_instance_of ISRTable, table_weekly
  end

  def test_initialize_with_invalid_frequency_raises
    error = assert_raises(RuntimeError) { ISRTable.new(:daily) }
    assert_match(/Invalid frequency/, error.message)
  end

  def test_calculate_isr_returns_zero_if_below_bracket
    table = ISRTable.new(:monthly)
    assert_equal 0, table.calculate_isr(0)
  end

  def test_calculate_isr_correct_for_monthly_brackets
    table = ISRTable.new(:monthly)

    # Using sample from monthly table bracket 5 (12935.83 to 15487.71)
    taxable_income = 13000
    bracket = table.instance_variable_get(:@brackets).find { |b| taxable_income >= b.lower_limit && taxable_income <= b.upper_limit }
    
    expected_isr = bracket.fixed_fee + (taxable_income - bracket.lower_limit) * bracket.rate
    result = table.calculate_isr(taxable_income)

    assert_in_delta expected_isr, result, 0.0001
  end

  def test_calculate_isr_correct_for_weekly_brackets
    table = ISRTable.new(:weekly)

    # Using sample from weekly table bracket 4 (2562.36 to 2978.64)
    taxable_income = 2700
    bracket = table.instance_variable_get(:@brackets).find { |b| taxable_income >= b.lower_limit && taxable_income <= b.upper_limit }
    
    expected_isr = bracket.fixed_fee + (taxable_income - bracket.lower_limit) * bracket.rate
    result = table.calculate_isr(taxable_income)

    assert_in_delta expected_isr, result, 0.0001
  end

  def test_calculate_isr_handles_infinity_upper_limit
    table = ISRTable.new(:monthly)

    high_income = 1_000_000
    bracket = table.instance_variable_get(:@brackets).last
    
    expected_isr = bracket.fixed_fee + (high_income - bracket.lower_limit) * bracket.rate
    result = table.calculate_isr(high_income)

    assert_in_delta expected_isr, result, 0.0001
  end
end
