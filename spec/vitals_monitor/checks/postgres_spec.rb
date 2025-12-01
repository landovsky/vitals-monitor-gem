# frozen_string_literal: true

require "rails_helper"

RSpec.describe VitalsMonitor::Checks::Postgres do
  let(:check) { described_class.new }

  describe "#check" do
    context "when ActiveRecord is available" do
      before do
        stub_const("ActiveRecord::Base", double(connection: double(execute: true)))
      end

      it "returns healthy status" do
        result = check.check
        expect(result[:status]).to eq(:healthy)
      end
    end

    context "when connection fails" do
      before do
        connection_double = double
        allow(connection_double).to receive(:execute).and_raise(StandardError.new("Connection failed"))
        stub_const("ActiveRecord::Base", double(connection: connection_double))
      end

      it "returns unhealthy status with error message" do
        result = check.check
        expect(result[:status]).to eq(:unhealthy)
        expect(result[:message]).to include("Connection failed")
      end
    end
  end
end
