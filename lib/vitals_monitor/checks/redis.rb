# frozen_string_literal: true

module VitalsMonitor
  module Checks
    class Redis < Base
      def check
        timeout do
          redis_client = redis_connection
          redis_client.ping
          healthy
        end
      rescue StandardError => e
        unhealthy("Redis connection failed: #{e.message}")
      end

      private

      def redis_connection
        if defined?(::Redis) && ::Redis.respond_to?(:current)
          ::Redis.current
        elsif defined?(::Redis) && Rails.application.config.respond_to?(:redis)
          ::Redis.new(Rails.application.config.redis)
        elsif defined?(Sidekiq) && Sidekiq.respond_to?(:redis)
          Sidekiq.redis { |conn| conn }
        else
          raise "Redis connection not configured"
        end
      end
    end
  end
end
