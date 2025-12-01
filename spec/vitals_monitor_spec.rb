# frozen_string_literal: true

require "spec_helper"

RSpec.describe VitalsMonitor do
  it "has a version number" do
    expect(VitalsMonitor::VERSION).not_to be nil
  end

  describe ".config" do
    it "returns a Configuration instance" do
      expect(VitalsMonitor.config).to be_a(VitalsMonitor::Configuration)
    end
  end

  describe ".configure" do
    it "yields the configuration" do
      VitalsMonitor.configure do |config|
        expect(config).to be_a(VitalsMonitor::Configuration)
      end
    end

    it "allows configuration changes" do
      VitalsMonitor.configure do |config|
        config.disable(:postgres)
      end
      expect(VitalsMonitor.config.enabled?(:postgres)).to be false
    end
  end
end
