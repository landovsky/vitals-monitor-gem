# frozen_string_literal: true

require_relative "vitals_monitor/version"
require_relative "vitals_monitor/configuration"

# Health checks
require_relative "vitals_monitor/checks/base"
require_relative "vitals_monitor/checks/postgres"
require_relative "vitals_monitor/checks/redis"
require_relative "vitals_monitor/checks/sidekiq"

# Require engine only if Rails is available
if defined?(Rails)
  require_relative "vitals_monitor/engine"
end

module VitalsMonitor
  class Error < StandardError; end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config if block_given?
  end
end
