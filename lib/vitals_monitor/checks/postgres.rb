# frozen_string_literal: true

module VitalsMonitor
  module Checks
    class Postgres < Base
      def check
        timeout do
          connection = ActiveRecord::Base.connection
          connection.execute("SELECT 1")
          healthy
        end
      rescue StandardError => e
        unhealthy("PostgreSQL connection failed: #{e.message}")
      end
    end
  end
end
