module Goodguide
  module Health
    class ApplicationController < ActionController::Base
      caches_action false if respond_to? :caches_action

      def show
        render text: 'OK'
      end

      def status
        render json: {
          app: app_name,
          revision: revision,
          deployed_at: deployed_at,
          host: `hostname`.chomp
        }
      end

      def error
        raise 'O NOES'
      end

      private

      def app_name
        @app_name ||= Rails.application.class.parent_name.underscore
      end

      def revision
        @revision ||= Object.const_defined?(:CODE_REVISION) ?
          CODE_REVISION :
          `git rev-parse HEAD`.chomp
      end

      def deployed_at
        @deployed_at ||= Object.const_defined?(:CODE_DEPLOYMENT_TIMESTAMP) ?
          Time.at(CODE_DEPLOYMENT_TIMESTAMP) :
          Time.now
      end
    end
  end
end
