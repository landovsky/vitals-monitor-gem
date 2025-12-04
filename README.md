# VitalsMonitor

A Rails engine that provides health check endpoints for monitoring Postgres, Redis, and Sidekiq. Components can be enabled or disabled via configuration, and endpoints return HTML or JSON with appropriate HTTP status codes for external monitoring systems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vitals_monitor'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install vitals_monitor
```

## Configuration

### Generate Initializer

After installing the gem, generate the initializer file:

```bash
$ rake vitals_monitor:install
```

This command must be run from your Rails application root directory. It will:
- Generate the initializer file at `config/initializers/vitals_monitor.rb`
- Automatically add the mount statement to your `config/routes.rb` file

This will create `config/initializers/vitals_monitor.rb` with default configuration:

```ruby
VitalsMonitor.configure do |config|
  # Enable or disable specific components
  # By default, all components are enabled
  config.enable(:postgres)
  config.enable(:redis)
  config.enable(:sidekiq)

  # Or disable specific components
  # config.disable(:sidekiq)
end
```

### Manual Configuration

Alternatively, you can create the initializer file manually at `config/initializers/vitals_monitor.rb` with the configuration above.

## Mounting the Engine

In your `config/routes.rb`, mount the engine:

```ruby
Rails.application.routes.draw do
  mount VitalsMonitor::Engine => '/vitals'
end
```

## Usage

### Endpoints

#### GET /vitals

Returns the health status of all enabled components.

**HTML Response:**
- Returns 200 OK if all components are healthy
- Returns 503 Service Unavailable if any component is unhealthy

**JSON Response:**
```json
{
  "status": "healthy",
  "components": {
    "postgres": {
      "status": "healthy",
      "message": null
    },
    "redis": {
      "status": "healthy",
      "message": null
    },
    "sidekiq": {
      "status": "healthy",
      "message": "Processed: 1234, Failed: 0, Enqueued: 5"
    }
  }
}
```

#### GET /vitals/:component

Returns the health status of a specific component. Valid components are: `postgres`, `redis`, `sidekiq`.

**HTML Response:**
- Returns 200 OK if the component is healthy
- Returns 503 Service Unavailable if the component is unhealthy
- Returns 404 Not Found if the component is not enabled

**JSON Response:**
```json
{
  "component": "postgres",
  "status": "healthy",
  "message": null
}
```

### Examples

Check all components:
```bash
curl http://localhost:3000/vitals
curl http://localhost:3000/vitals.json
```

Check a specific component:
```bash
curl http://localhost:3000/vitals/postgres
curl http://localhost:3000/vitals/redis.json
curl http://localhost:3000/vitals/sidekiq
```

### Monitoring Integration

The endpoints return appropriate HTTP status codes, making them suitable for monitoring systems:

- **200 OK**: All components are healthy
- **503 Service Unavailable**: One or more components are unhealthy
- **404 Not Found**: Component is not enabled or doesn't exist

This allows you to use the endpoints with monitoring tools like:
- Kubernetes liveness/readiness probes
- AWS ELB health checks
- Nagios/Icinga checks
- Any HTTP-based monitoring system

## Health Checks

### PostgreSQL

Checks the database connection by executing a simple query. Requires ActiveRecord to be configured.

### Redis

Checks the Redis connection by attempting to ping the server. Supports multiple Redis configurations:
- `Redis.current` (if available)
- `Rails.application.config.redis` (if configured)
- Sidekiq's Redis connection (if Sidekiq is available)

### Sidekiq

Checks Sidekiq's health by accessing its statistics. Requires Sidekiq to be configured and available.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/landovsky/vitals_monitor-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/landovsky/vitals_monitor-gem/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VitalsMonitor project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/landovsky/vitals_monitor-gem/blob/main/CODE_OF_CONDUCT.md).
