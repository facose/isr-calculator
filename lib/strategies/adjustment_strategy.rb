# Base class for ISR adjustment strategies
# Provides a common interface for calculating ISR based on different adjustment methods
# Subclasses must implement the calculate_isr method
class AdjustmentStrategy
  def calculate_isr(employee)
    raise NotImplementedError, "#{self.class} must implement #calculate_isr"
  end
end
