# frozen_string_literal: true

module VitalsMonitor
  class Configuration
    attr_accessor :enabled_components

    def initialize
      @enabled_components = {
        postgres: true,
        redis: true,
        sidekiq: true
      }
    end

    def enabled?(component)
      @enabled_components[component.to_sym] == true
    end

    def enable(component)
      @enabled_components[component.to_sym] = true
    end

    def disable(component)
      @enabled_components[component.to_sym] = false
    end
  end
end
