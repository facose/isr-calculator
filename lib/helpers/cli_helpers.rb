module CLIHelpers
  # Provides helper methods for CLI interactions
  def prompt(message)
    print message
    gets.strip
  end

  # Prompts the user to select an adjustment type
  def choose_adjustment_type
    puts "\nSelecciona el tipo de ajuste:"
    puts "1. Sin ajuste"
    puts "2. Ajuste básico"
    puts "3. Ajuste proyectado"

    case prompt("> ").to_i
    when 1 then :no_adjustment
    when 2 then :basic_adjustment
    when 3 then :projected_adjustment
    else
      warn "Opción inválida. Saliendo..."
      exit(1)
    end
  end

  # Prompts for a float input
  def prompt_float(message)
    loop do
      input = prompt(message)
      return input.to_f if input.match?(/^\d+(\.\d+)?$/)

      puts "Por favor ingresa un número válido."
    end
  end

  # Prompts for an integer input
  def prompt_integer(message)
    loop do
      input = prompt(message)
      return input.to_i if input.match?(/^\d+$/)

      puts "Por favor ingresa un número entero válido."
    end
  end
end
