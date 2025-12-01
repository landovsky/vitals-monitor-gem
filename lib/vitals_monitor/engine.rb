# frozen_string_literal: true

require "rails/engine"

module VitalsMonitor
  class Engine < ::Rails::Engine
    isolate_namespace VitalsMonitor

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
