class Employee
  attr_reader :name, :adjustment_type, :weeks

  def initialize(name:, adjustment_type:)
    @name = name
    @adjustment_type = adjustment_type # :no_adjustment, :basic_adjustment, :projected_adjustment
    @weeks = []
  end

  def add_week(week)
    weeks << week
  end

  def calculate_isr
    strategy.calculate_isr(self)
  end

  private

  def strategy
    case adjustment_type
    when :no_adjustment then NoAdjustment.new
    when :basic_adjustment then BasicAdjustment.new
    when :projected_adjustment then ProjectedAdjustment.new
    else raise "Unknown adjustment type"
    end
  end
end
