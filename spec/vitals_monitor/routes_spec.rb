# frozen_string_literal: true

require "rails_helper"

RSpec.describe "VitalsMonitor routes", type: :routing do
  routes { VitalsMonitor::Engine.routes }

  describe "GET /" do
    it "routes to vitals#index" do
      expect(get: "/").to route_to(controller: "vitals_monitor/vitals", action: "index")
    end
  end

  describe "GET /:component" do
    it "routes to vitals#show for postgres" do
      expect(get: "/postgres").to route_to(controller: "vitals_monitor/vitals", action: "show", component: "postgres")
    end

    it "routes to vitals#show for redis" do
      expect(get: "/redis").to route_to(controller: "vitals_monitor/vitals", action: "show", component: "redis")
    end

    it "routes to vitals#show for sidekiq" do
      expect(get: "/sidekiq").to route_to(controller: "vitals_monitor/vitals", action: "show", component: "sidekiq")
    end

    it "does not route invalid components" do
      expect(get: "/invalid").not_to be_routable
    end
  end
end
