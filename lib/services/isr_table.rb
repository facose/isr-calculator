class ISRTable
  # Represents a tax bracket with limits, fixed fee, and rate
  # lower_limit: Minimum income for the bracket
  # upper_limit: Maximum income for the bracket
  # fixed_fee: Fixed amount applied to the income in this bracket
  # rate: Percentage rate applied to the excess income over lower_limit
  Bracket = Struct.new(:lower_limit, :upper_limit, :fixed_fee, :rate)

  def initialize(frequency)
    @brackets = case frequency
                when :monthly then load_monthly_table
                when :weekly then load_weekly_table
                else raise "Invalid frequency"
                end
  end

  # Calculates ISR based on the taxable income and the applicable bracket
  def calculate_isr(taxable_income)
    bracket = @brackets.find do |b|
      taxable_income >= b.lower_limit && taxable_income <= b.upper_limit
    end

    return 0 unless bracket

    excess = taxable_income - bracket.lower_limit
    bracket.fixed_fee + excess * bracket.rate
  end

  private

  def load_monthly_table
    [
      Bracket.new(0.01, 746.04, 0, 0.0192),
      Bracket.new(746.05, 6332.05, 14.32, 0.064),
      Bracket.new(6332.06, 11128.01, 371.83, 0.1088),
      Bracket.new(11128.02, 12935.82, 893.63, 0.16),
      Bracket.new(12935.83, 15487.71, 1182.88, 0.1792),
      Bracket.new(15487.72, 31236.49, 1640.18, 0.2136),
      Bracket.new(31236.50, 49233.00, 5004.12, 0.2352),
      Bracket.new(49233.01, 93993.90, 9236.89, 0.3),
      Bracket.new(93993.91, 125325.20, 22665.17, 0.32),
      Bracket.new(125325.21, 375975.61, 32691.18, 0.34),
      Bracket.new(375975.62, Float::INFINITY, 117912.32, 0.35),
    ]
  end

  def load_weekly_table
    [
      Bracket.new(0.01, 171.78, 0, 0.0192),
      Bracket.new(171.79, 1458.03, 3.29, 0.064),
      Bracket.new(1458.04, 2562.35, 85.61, 0.1088),
      Bracket.new(2562.36, 2978.64, 205.8, 0.16),
      Bracket.new(2978.65, 3566.22, 272.37, 0.1792),
      Bracket.new(3566.23, 7192.64, 377.65, 0.2136),
      Bracket.new(7192.65, 11336.57, 1152.27, 0.2352),
      Bracket.new(11336.58, 21643.30, 2126.95, 0.3),
      Bracket.new(21643.31, 28857.78, 5218.92, 0.32),
      Bracket.new(28857.79, 86573.34, 7527.59, 0.34),
      Bracket.new(86573.35, Float::INFINITY, 27150.83, 0.35),
    ]
  end
end
