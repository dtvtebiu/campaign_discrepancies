require 'sequel'

Sequel.connect('sqlite://db/development.db')

Dir[File.expand_path('lib/**/*.rb')].each { |file| require file }

task :show_discrepancies do
  puts Services::DiscrepanciesDetector.new.call
end
