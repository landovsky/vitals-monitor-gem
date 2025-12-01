# frozen_string_literal: true

require "rails_helper"

RSpec.describe VitalsMonitor::Checks::Sidekiq do
  let(:check) { described_class.new }

  describe "#check" do
    context "when Sidekiq is available" do
      let(:stats) { double(processed: 100, failed: 0, enqueued: 5) }

      before do
        stub_const("Sidekiq::Stats", double(new: stats))
      end

      it "returns healthy status" do
        result = check.check
        expect(result[:status]).to eq(:healthy)
        expect(result[:message]).to include("Processed")
      end
    end

    context "when Sidekiq is not available" do
      before do
        hide_const("Sidekiq")
      end

      it "returns unhealthy status" do
        result = check.check
        expect(result[:status]).to eq(:unhealthy)
        expect(result[:message]).to include("not available")
      end
    end

    context "when Sidekiq connection fails" do
      let(:stats) { double }

      before do
        allow(stats).to receive(:processed).and_raise(StandardError.new("Connection failed"))
        stub_const("Sidekiq::Stats", double(new: stats))
      end

      it "returns unhealthy status with error message" do
        result = check.check
        expect(result[:status]).to eq(:unhealthy)
        expect(result[:message]).to include("Connection failed")
      end
    end
  end
end
