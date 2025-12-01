# frozen_string_literal: true

require "rails_helper"

RSpec.describe VitalsMonitor::Checks::Redis do
  let(:check) { described_class.new }

  describe "#check" do
    context "when Redis.current is available" do
      let(:redis_client) { double(ping: "PONG") }

      before do
        stub_const("Redis", double(current: redis_client))
      end

      it "returns healthy status" do
        result = check.check
        expect(result[:status]).to eq(:healthy)
      end
    end

    context "when connection fails" do
      let(:redis_client) { double }

      before do
        allow(redis_client).to receive(:ping).and_raise(StandardError.new("Connection failed"))
        stub_const("Redis", double(current: redis_client))
      end

      it "returns unhealthy status with error message" do
        result = check.check
        expect(result[:status]).to eq(:unhealthy)
        expect(result[:message]).to include("Connection failed")
      end
    end
  end
end
