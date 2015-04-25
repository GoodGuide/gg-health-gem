require 'goodguide/health'

Goodguide::Health.configure do |health|
  health.check :foo do
    true
  end
end

run Goodguide::Health.app
