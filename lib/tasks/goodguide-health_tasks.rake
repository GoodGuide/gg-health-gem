require File.expand_path('../../../app/models/goodguide/health/maintenance', __FILE__)

namespace :maintenance do
  desc "Enable maintenance mode"
  task :enable do
    message = ENV.fetch('MESSAGE', '')
    Goodguide::Health::Maintenance.instance.enable!(message)

    if message.present?
      puts "Enabled maintenance mode with message:\n#{message}"
    else
      puts "Enabled maintenance mode with default message."
    end
  end

  desc "Disable maintenance mode"
  task :disable do
    Goodguide::Health::Maintenance.instance.disable!
    puts "Disabled maintenance mode."
  end
end
