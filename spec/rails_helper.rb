# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "rails"
require "action_controller/railtie"
require "rspec/rails"

require "vitals_monitor"

# Ensure Rails is defined and engine is loaded
if defined?(Rails)
  require_relative "../lib/vitals_monitor/engine"
end

# Explicitly require the controller for testing
require_relative "../app/controllers/vitals_monitor/vitals_controller"

# Create a minimal Rails app for testing
unless defined?(TestApp)
  module TestApp
    class Application < Rails::Application
      config.root = File.expand_path("tmp", __dir__)
      config.eager_load = false
      config.secret_key_base = "test_secret_key_base"
    end
  end

  TestApp::Application.initialize! unless TestApp::Application.initialized?
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
