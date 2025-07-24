require_relative 'adjustment_strategy'

class ProjectedAdjustment < AdjustmentStrategy
  # Calculates ISR for each week using projected adjustment method
  # The last week applies a monthly correction based on total income
  # Returns an array of hashes with week number, salary, and calculated ISR
  def calculate_isr(employee)
    monthly_table = ISRTable.new(:monthly)
    results = []
    cumulative_income = 0.0
    cumulative_days = 0
    cumulative_isr = 0.0
    total_weeks = employee.weeks.size

    return results if total_weeks.zero? # Handle case with no weeks
    
    # Iterate through each week to calculate ISR
    # The last week behaves like basic adjustment
    # The rest are projected based on cumulative income and days worked
    employee.weeks.each_with_index do |week, index|
      is_last_week = index == total_weeks - 1
      salary = week.salary
      days = week.days_worked.clamp(1, 7)

      cumulative_income += salary
      cumulative_days += days

      if is_last_week
        # Final week behaves like basic adjustment
        total_income = employee.weeks.sum(&:salary)
        expected_monthly_isr = monthly_table.calculate_isr(total_income)
        final_week_isr = [expected_monthly_isr - cumulative_isr, 0.0].max # Ensure ISR is not negative

        results << {
          week: week.number,
          salary: salary,
          isr: format('%.2f', final_week_isr).to_f
        }
      else
        # Projected ISR
        remaining_weeks = total_weeks - index - 1
        projected_total_days = cumulative_days + (remaining_weeks * 7)

        # Calculate projected income based on daily average
        daily_income = cumulative_days > 0 ? cumulative_income / cumulative_days : 0.0
        projected_income = daily_income * projected_total_days
        projected_monthly_isr = monthly_table.calculate_isr(projected_income)

        # Calculate ISR for the week based on projected monthly ISR
        week_ratio = days.to_f / projected_total_days
        week_isr = projected_monthly_isr * week_ratio

        cumulative_isr += week_isr

        results << {
          week: week.number,
          salary: salary,
          isr: format('%.2f', week_isr).to_f
        }
      end
    end

    results
  end
end
