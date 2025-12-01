# frozen_string_literal: true

module VitalsMonitor
  module Checks
    class Sidekiq < Base
      def check
        timeout do
          unless defined?(::Sidekiq)
            return unhealthy("Sidekiq is not available")
          end

          stats = ::Sidekiq::Stats.new

          # Check if Sidekiq can connect to Redis
          stats.processed

          healthy("Processed: #{stats.processed}, Failed: #{stats.failed}, Enqueued: #{stats.enqueued}")
        end
      rescue StandardError => e
        unhealthy("Sidekiq health check failed: #{e.message}")
      end
    end
  end
end
