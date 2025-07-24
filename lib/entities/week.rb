class Week
  attr_reader :number, :salary, :days_worked

  def initialize(number:, salary:, days_worked: 7)
    @number = number
    @salary = salary
    @days_worked = days_worked
  end
end
