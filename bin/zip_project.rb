#!/usr/bin/env ruby
zip_name = "isr_calculator.zip"

puts "Zipping lib/, bin/, and README.md into #{zip_name}..."

# Create the zip
system("zip -r #{zip_name} lib bin README.md")

puts "Done!"
