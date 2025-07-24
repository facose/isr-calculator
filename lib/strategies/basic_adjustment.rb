require_relative 'adjustment_strategy'

class BasicAdjustment < AdjustmentStrategy
  # Calculates ISR for each week using basic adjustment method
  # The last week applies a monthly correction based on total income
  # Returns an array of hashes with week number, salary, and calculated ISR
  def calculate_isr(employee)
    weekly_table = ISRTable.new(:weekly)
    monthly_table = ISRTable.new(:monthly)

    isr_results = []
    accumulated_isr = 0.0
    total_income = 0.0
    last_week_index = employee.weeks.size - 1

    # Iterate through each week to calculate ISR
    employee.weeks.each_with_index do |week, index|
      total_income += week.salary

      if index == last_week_index
        # Apply monthly correction
        expected_monthly_isr = monthly_table.calculate_isr(total_income)
        last_week_isr = [expected_monthly_isr - accumulated_isr, 0.0].max # Ensure ISR is not negative

        isr_results << {
          week: week.number,
          salary: week.salary,
          isr: last_week_isr.round(2)
        }
      else
        weekly_isr = weekly_table.calculate_isr(week.salary)
        accumulated_isr += weekly_isr

        isr_results << {
          week: week.number,
          salary: week.salary,
          isr: weekly_isr.round(2)
        }
      end
    end

    isr_results
  end
end
