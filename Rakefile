require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc "Run the ISR calculator CLI app"
task :run_app do
  sh "ruby bin/isr_calculator.rb"
end

desc "Zip the project"
task :zip_project do
  sh "ruby bin/zip_project.rb"
end
