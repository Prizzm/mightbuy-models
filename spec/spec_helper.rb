__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
# Configure Rails Environment

$LOAD_PATH.unshift __LIB_DIR__

require "mightbuy_models"

Rails.backtrace_cleaner.remove_silencers!
db_connection()

Dir["spec/support/*.rb"].each {|file| require file }
Dir["app/models/*.rb"].each { |model| require model }

RSpec.configure do |config|
  config.mock_with :rspec
  config.include OAuthSpecHelper
  config.include TopicSpecHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start()
  end

  config.after(:each) do
    DatabaseCleaner.clean()
  end
end

def db_connection
  require "yaml"
  begin
    db_config = YAML.load_file(File.join(File.dirname(__FILE__), "database.yml"))['test']
    db_config.symbolize_keys!
    ActiveRecord::Base.establish_connection(db_config)
  rescue
    puts $!.message
    puts "Error connecting with credentials #{db_config.inspect}"
  end
end
