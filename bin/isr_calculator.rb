#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

# Require all files inside lib/entities, lib/strategies, lib/services, lib/helpers
Dir[File.join(__dir__, '../lib', '{entities,strategies,services,helpers}', '*.rb')].sort.each { |file| require file }

include CLIHelpers

# Main CLI flow
puts "Calculadora ISR semanal (México)"
puts "-----------------------------------"

# Prompt for employee name and adjustment type
name = prompt("Ingresa el nombre del empleado: ")
adjustment_type = choose_adjustment_type
# Create employee instance with the selected adjustment type
employee = Employee.new(name: name, adjustment_type: adjustment_type)

# Prompt for number of weeks worked in the month
total_weeks = prompt_integer("\n¿Cuántas semanas trabajó en el mes? ")

(1..total_weeks).each do |week_number|
  puts "\n--- Semana #{week_number} ---"

  # Prompt for salary and days worked
  salary = prompt_float("Ingresa el salario para la semana #{week_number}: ")

  days_worked = 7
  if adjustment_type == :projected_adjustment
    # For projected adjustment, prompt for actual days worked
    days_worked = prompt_integer("Ingresa el número de días trabajados (1-7): ")
  end

  # Add week to employee
  employee.add_week(Week.new(number: week_number, salary: salary, days_worked: days_worked))
end

puts "\nResultados de la Calculadora ISR para #{employee.name}:"
puts "-----------------------------------"

# Calculate ISR using the selected adjustment strategy
total_isr = 0.0
employee.calculate_isr.each do |result|
  puts "Semana #{result[:week]} | Salario: $#{format('%.2f', result[:salary])} | ISR: $#{format('%.2f', result[:isr])}"
  total_isr += result[:isr]
end

puts "-----------------------------------"
puts "Total de ISR para el mes: $#{format('%.2f', total_isr)}"
