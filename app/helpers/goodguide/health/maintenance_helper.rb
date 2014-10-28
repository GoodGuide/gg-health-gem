module Goodguide
  module Health
    module MaintenanceHelper
      def redirect_if_maintenance_mode(path)
        if maintenance? && request.path != path && request.path !~ /health/
          redirect_to path
        end
      end

      def maintenance?
        Goodguide::Health::Maintenance.instance.enabled?
      end

      def maintenance_message
        Goodguide::Health::Maintenance.instance.message
      end
    end
  end
end
