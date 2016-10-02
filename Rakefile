require "rake/testtask"
Dir[File.expand_path('../lib/*', __FILE__)].each {|file| require file }

Rake::TestTask.new :test do |t|
  t.pattern = "**/*_test.rb"
  t.verbose = true
end

desc 'Run mission from file'
task :run_mission, [:file_name] do |t, args|
  operator = Operator.new
  operator.load_directions! File.expand_path(args[:file_name])
  puts "Initial rover status:\n"
  puts operator.rover_status_report
  operator.run_mission!
  puts "Mission completion rover status:\n"
  puts operator.rover_status_report
end