__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
current_dir = File.expand_path(File.dirname(__FILE__))
# Configure Rails Environment

$LOAD_PATH.unshift __LIB_DIR__

ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
require "bundler"
Bundler.require(:default,'test')

require_relative "#{current_dir}/../config/devise_initializer"
require "mightbuy_models"

Rails.backtrace_cleaner.remove_silencers!

require "yaml"
begin
  db_config = YAML.load_file(File.join(File.dirname(__FILE__), "database.yml"))['test']
  db_config.symbolize_keys!
  ActiveRecord::Base.establish_connection(db_config)
rescue
  puts $!.message
  puts "Error connecting with credentials #{db_config.inspect}"
end

Dir["#{current_dir}/spec/support/*.rb"].each {|file| require file }
Dir["#{current_dir}/../app/models/**/*.rb"].each { |model| require model }

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

