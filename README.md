# Goodguide::Health

This is a very simple Rack application which provides GoodGuide's internal notion of a health-check endpoint to apps which embed it.

## Configuration

Goodguide::Health is mainly a wrapper around our fork of [Pinglish][], which is a simple Rack app which provides a "ping" endpoint which has a few powerful guarantees and enables the creation of arbitrary "health check" procs each of which are run during a status check.

This is exposed for configuration as in the following example:

```ruby
# config/initializers/health.rb

Goodguide::Health.configure do |health|
  health.check :foo do
    # health check logic
  end
end
```

Please see the Pinglish docs/source for more info on exactly the semantics of the health checks and how they are meant to be used.

Goodguide::Health is a singleton class, which makes configuration easy when you usually will have to inject the configured instance into a Rails routes table earlier in the boot process.

## Usage

In the simple case, you can just `mount` it in a Rails app:

```ruby
# config/routes.rb
MyAwesomeRailsApp::Application.routes.draw do
  mount Goodguide::Health.app, at: '/health', as: 'health'
end
```

(`#app` exposes the composed Rack app which mounts [Pinglish][] at `/status`)

Or in a more basic Rack context, you can `run` it directly:

```ruby
# config.ru
map '/health' do
  run Goodguide::Health.app
end

run MyAwesomeRackApp
```

[Pinglish]: https://github.com/goodguide/pinglish
