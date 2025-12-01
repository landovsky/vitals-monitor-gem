# frozen_string_literal: true

require "timeout"

module VitalsMonitor
  module Checks
    class Base
      TIMEOUT = 5 # seconds

      def check
        raise NotImplementedError, "Subclasses must implement #check"
      end

      protected

      def healthy(message = nil)
        { status: :healthy, message: message }
      end

      def unhealthy(message)
        { status: :unhealthy, message: message }
      end

      def timeout
        Timeout.timeout(TIMEOUT) do
          yield
        end
      rescue Timeout::Error
        unhealthy("Health check timed out after #{TIMEOUT} seconds")
      end
    end
  end
end
