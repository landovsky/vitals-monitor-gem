# frozen_string_literal: true

module VitalsMonitor
  module Formatters
    class Json
      def self.format_all(results, overall_status)
        {
          status: overall_status,
          components: results.transform_values do |result|
            {
              status: result[:status],
              message: result[:message]
            }
          end
        }
      end

      def self.format_single(component, result)
        {
          component: component.to_s,
          status: result[:status],
          message: result[:message]
        }
      end
    end
  end
end
