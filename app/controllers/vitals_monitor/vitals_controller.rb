# frozen_string_literal: true

module VitalsMonitor
  class VitalsController < ActionController::Base
    before_action :set_format

    def index
      @results = check_all_components
      @overall_status = overall_status(@results)
      status_code = @overall_status == :unhealthy ? 503 : 200

      respond_to do |format|
        format.html { render status: status_code }
        format.json { render json: format_json_response(@results, @overall_status), status: status_code }
      end
    end

    def show
      component = params[:component].to_sym

      unless VitalsMonitor.config.enabled?(component)
        respond_to do |format|
          format.html { render status: 404 }
          format.json { render json: { error: "Component #{component} is not enabled" }, status: 404 }
        end
        return
      end

      result = check_component(component)
      @result = result
      @component = component
      @status = result[:status]
      status_code = result[:status] == :unhealthy ? 503 : 200

      respond_to do |format|
        format.html { render status: status_code }
        format.json { render json: format_single_json_response(component, result), status: status_code }
      end
    end

    private

    def set_format
      request.format = :html unless request.format.json?
    end

    def check_all_components
      results = {}
      %i[postgres redis sidekiq].each do |component|
        results[component] = check_component(component) if VitalsMonitor.config.enabled?(component)
      end
      results
    end

    def check_component(component)
      case component
      when :postgres
        VitalsMonitor::Checks::Postgres.new.check
      when :redis
        VitalsMonitor::Checks::Redis.new.check
      when :sidekiq
        VitalsMonitor::Checks::Sidekiq.new.check
      else
        { status: :unhealthy, message: "Unknown component: #{component}" }
      end
    end

    def overall_status(results)
      return :unhealthy if results.empty?
      return :unhealthy if results.values.any? { |r| r[:status] == :unhealthy }

      :healthy
    end

    def format_json_response(results, overall_status)
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

    def format_single_json_response(component, result)
      {
        component: component.to_s,
        status: result[:status],
        message: result[:message]
      }
    end
  end
end
