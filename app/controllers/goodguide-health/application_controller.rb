module GoodguideHealth
  class ApplicationController < ActionController::Base
    caches_action false

    def show
      render :text => 'OK'
    end

    def status
      render :json => {
        app: app_name,
        revision: revision,
        deployed_at: deployed_at,
        host: %x(hostname).chomp,
      }
    end

    def error
      raise 'O NOES'
    end

    private

    def app_name
      # stupid stupid stupid
      # sometimes Rails.application is a class,
      # sometimes it's an instance.
      app_class = Rails.application
      app_class = app_class.class unless app_class.is_a? Class

      app_class.parent_name.underscore
    end

    def revision
      @revision ||= Object.const_defined?(:CODE_REVISION) ?
        CODE_REVISION :
        %x[git rev-parse HEAD].chomp
    end

    def deployed_at
      @deployed_at ||= Object.const_defined?(:CODE_DEPLOYMENT_TIMESTAMP) ?
        Time.at(CODE_DEPLOYMENT_TIMESTAMP) :
        Time.now
    end
  end
end
