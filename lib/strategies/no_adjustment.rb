require_relative 'adjustment_strategy'

class NoAdjustment < AdjustmentStrategy
  # Calculates ISR for each week without any adjustment
  # Returns an array of hashes with week number, salary, and calculated ISR
  # Uses the weekly ISR table for calculations
  def calculate_isr(employee)
    table = ISRTable.new(:weekly)
    employee.weeks.map do |week|
      isr = table.calculate_isr(week.salary)
      { week: week.number, salary: week.salary, isr: isr.round(2) }.freeze
    end
  end
end
