require 'singleton'

module Goodguide
  module Health
    class Maintenance
      include Singleton

      def enabled?
        File.exist?(path)
      end

      def message
        return unless enabled?

        message = File.read(path)
        message.blank? ? false : message
      end

      def disable!
        File.delete(path) if enabled?
      end

      def enable!(message=nil)
        file = File.open(path, 'w')
        file << message
        file.close
      end

      private

      def path
        Rails.root.join('config/maintenance.enabled')
      end
    end
  end
end
