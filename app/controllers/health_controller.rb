class HealthController < ApplicationController
  def show
    render :text => 'OK'
  end

  def status
    render :json => {
      app: 'api',
      revision: revision,
      deployed_at: deployed_at,
      host: %x(hostname).chomp,
    }
  end

  def error
    raise 'O NOES'
  end

  private

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
