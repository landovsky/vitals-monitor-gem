# frozen_string_literal: true

require "spec_helper"

RSpec.describe VitalsMonitor::Configuration do
  let(:config) { described_class.new }

  describe "#initialize" do
    it "enables all components by default" do
      expect(config.enabled?(:postgres)).to be true
      expect(config.enabled?(:redis)).to be true
      expect(config.enabled?(:sidekiq)).to be true
    end
  end

  describe "#enabled?" do
    it "returns true for enabled components" do
      config.enable(:postgres)
      expect(config.enabled?(:postgres)).to be true
    end

    it "returns false for disabled components" do
      config.disable(:postgres)
      expect(config.enabled?(:postgres)).to be false
    end

    it "handles string and symbol inputs" do
      config.enable(:postgres)
      expect(config.enabled?("postgres")).to be true
      expect(config.enabled?(:postgres)).to be true
    end
  end

  describe "#enable" do
    it "enables a component" do
      config.disable(:postgres)
      config.enable(:postgres)
      expect(config.enabled?(:postgres)).to be true
    end
  end

  describe "#disable" do
    it "disables a component" do
      config.enable(:postgres)
      config.disable(:postgres)
      expect(config.enabled?(:postgres)).to be false
    end
  end
end
