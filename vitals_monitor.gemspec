# frozen_string_literal: true

require_relative "lib/vitals_monitor/version"

Gem::Specification.new do |spec|
  spec.name = "vitals_monitor"
  spec.version = VitalsMonitor::VERSION
  spec.authors = ["Tomáš Landovský"]
  spec.email = ["landovsky@gmail.com"]

  spec.summary = "Rails engine providing health check endpoints for Postgres, Redis, and Sidekiq"
  spec.description = "VitalsMonitor is a Rails engine that provides /vitals endpoints to monitor the health status of Postgres, Redis, and Sidekiq. Components can be enabled/disabled via configuration, and endpoints return HTML or JSON with appropriate HTTP status codes for monitoring."
  spec.homepage = "https://github.com/landovsky/vitals_monitor"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/landovsky/vitals_monitor"
  spec.metadata["changelog_uri"] = "https://github.com/landovsky/vitals_monitor/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "rails", ">= 5.2"

  # Optional dependencies (for health checks)
  spec.add_development_dependency "pg", "~> 1.0"
  spec.add_development_dependency "redis", "~> 4.0"
  spec.add_development_dependency "sidekiq", "~> 6.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
