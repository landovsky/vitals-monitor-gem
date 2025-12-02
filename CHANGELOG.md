# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2025-12-02
### Fixed
Redis detection.


## [0.1.0] - 2025-12-01
### Added

- Health check endpoints for Postgres, Redis, and Sidekiq
- Configuration system to enable/disable components via initializer
- HTML and JSON response formats for all endpoints
- HTTP status codes (200 for healthy, 503 for unhealthy) for monitoring integration
- Rake install task (`rake vitals_monitor:install`) to generate initializer and mount routes
- Comprehensive test suite with RSpec
- RBS type signatures for type checking support
- Rails engine integration with isolated namespace

### Fixed

- Engine routes now correctly use root path (`/`) instead of `/vitals` to work properly when mounted
- Proper Rails app detection in install task to avoid modifying gem's own routes file

### Changed

- Routes are now relative to mount point (standard Rails engine pattern)
  - Mounted at `/vitals` → `/vitals` routes to index
  - Mounted at `/vitals` → `/vitals/:component` routes to show


- Initial release
