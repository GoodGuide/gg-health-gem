module Goodguide
  module Health
    class Engine < ::Rails::Engine
      isolate_namespace Goodguide::Health

      initializer 'goodguide-health.load_helpers' do |app|
        ActionController::Base.send :include, MaintenanceHelper
      end
    end
  end
end
