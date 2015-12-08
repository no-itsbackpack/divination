$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'active_record'
require 'divination'

begin
  require 'rails'
rescue LoadError
end

require 'bundler/setup'
Bundler.require

require 'database_cleaner'

# Simulate a gem providing a subclass of ActiveRecord::Base before the Railtie is loaded.
require 'fake_gem' if defined? ActiveRecord

if defined? Rails
  require 'test_app/rails_app'

  require 'rspec/rails'
end
require 'rspec/its'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr
  config.filter_run_excluding :generator_spec => true if !ENV['GENERATOR_SPEC']
end
