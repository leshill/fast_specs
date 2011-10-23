require 'database_cleaner'

RSpec.configure do |config|
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end
