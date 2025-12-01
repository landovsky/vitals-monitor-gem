# frozen_string_literal: true

VitalsMonitor.configure do |config|
  # Enable or disable specific components
  # By default, all components are enabled
  config.enable(:postgres)
  config.enable(:redis)
  config.enable(:sidekiq)

  # Or disable specific components
  # config.disable(:sidekiq)
end
