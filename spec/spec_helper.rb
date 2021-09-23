# frozen_string_literal: true

begin
  require "pry-byebug"
rescue LoadError
end

ENV["RAILS_ENV"] = "test"

require "combustion"

Combustion.initialize! :active_record, :action_controller, :action_view, :action_cable do
  config.logger = Logger.new(nil)
  config.log_level = :fatal

  config.action_cable.url = "ws://jwt.anycable.io/cable"
end

require "rspec/rails"
require "anycable-rails-jwt"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed
end
