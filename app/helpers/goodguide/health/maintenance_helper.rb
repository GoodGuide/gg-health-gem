module Goodguide
  module Health
    module MaintenanceHelper
      def maintenance?
        Goodguide::Health::Maintenance.instance.enabled?
      end

      def maintenance_message
        Goodguide::Health::Maintenance.instance.message
      end
    end
  end
end
