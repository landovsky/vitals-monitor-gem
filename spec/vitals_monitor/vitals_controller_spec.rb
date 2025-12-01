# frozen_string_literal: true

require "rails_helper"

RSpec.describe VitalsMonitor::VitalsController, type: :controller do
  routes { VitalsMonitor::Engine.routes }

  before do
    allow(VitalsMonitor).to receive(:config).and_return(double(
      enabled?: true,
      enabled_components: { postgres: true, redis: true, sidekiq: true }
    ))
  end

  describe "GET #index" do
    context "when all components are healthy" do
      before do
        allow_any_instance_of(VitalsMonitor::Checks::Postgres).to receive(:check).and_return(status: :healthy)
        allow_any_instance_of(VitalsMonitor::Checks::Redis).to receive(:check).and_return(status: :healthy)
        allow_any_instance_of(VitalsMonitor::Checks::Sidekiq).to receive(:check).and_return(status: :healthy)
      end

      it "returns 200 status" do
        get :index
        expect(response.status).to eq(200)
      end

      it "returns HTML by default" do
        get :index
        expect(response.content_type).to include("text/html")
      end

      it "returns JSON when requested" do
        get :index, format: :json
        expect(response.content_type).to include("application/json")
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("healthy")
        expect(json["components"]).to be_present
      end
    end

    context "when a component is unhealthy" do
      before do
        allow_any_instance_of(VitalsMonitor::Checks::Postgres).to receive(:check).and_return(status: :unhealthy, message: "Connection failed")
        allow_any_instance_of(VitalsMonitor::Checks::Redis).to receive(:check).and_return(status: :healthy)
        allow_any_instance_of(VitalsMonitor::Checks::Sidekiq).to receive(:check).and_return(status: :healthy)
      end

      it "returns 503 status" do
        get :index
        expect(response.status).to eq(503)
      end

      it "returns unhealthy status in JSON" do
        get :index, format: :json
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("unhealthy")
      end
    end
  end

  describe "GET #show" do
    context "when component is healthy" do
      before do
        allow_any_instance_of(VitalsMonitor::Checks::Postgres).to receive(:check).and_return(status: :healthy)
      end

      it "returns 200 status" do
        get :show, params: { component: "postgres" }
        expect(response.status).to eq(200)
      end

      it "returns JSON when requested" do
        get :show, params: { component: "postgres" }, format: :json
        json = JSON.parse(response.body)
        expect(json["component"]).to eq("postgres")
        expect(json["status"]).to eq("healthy")
      end
    end

    context "when component is unhealthy" do
      before do
        allow_any_instance_of(VitalsMonitor::Checks::Postgres).to receive(:check).and_return(status: :unhealthy, message: "Connection failed")
      end

      it "returns 503 status" do
        get :show, params: { component: "postgres" }
        expect(response.status).to eq(503)
      end
    end

    context "when component is not enabled" do
      before do
        allow(VitalsMonitor.config).to receive(:enabled?).with(:postgres).and_return(false)
      end

      it "returns 404 status" do
        get :show, params: { component: "postgres" }, format: :json
        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json["error"]).to include("not enabled")
      end
    end
  end
end
