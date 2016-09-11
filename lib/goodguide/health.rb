require 'forwardable'
require 'rack/builder'
require 'rack/urlmap'
require 'pinglish'
require 'goodguide/health/version'

module Goodguide
  class Health
    class <<self
      extend Forwardable

      def app
        health = instance
        Rack::Builder.app do
          map '/status' do
            run health.pinglish
          end
          map '/' do
            run health
          end
        end
      end

      def reset
        @instance = nil
      end

      def_delegator :instance, :configure

      private

      def instance
        @instance ||= new
      end
    end

    def initialize
      @booted_at = Time.now
    end

    attr_reader :booted_at
    attr_writer :revision, :deployed_at, :hostname

    def hostname
      @hostname ||= ENV['DEPLOYMENT_HOST'] || ENV.fetch('HOSTNAME') {
        output = `hostname 2>/dev/null`
        $? == 0 ? output.chomp : nil
      }
    end

    def revision
      @revision ||= ENV.fetch('DEPLOYMENT_REVISION') {
        output = `git rev-parse HEAD 2>/dev/null`
        $? == 0 ? output.chomp : nil
      }
    end

    def deployed_at
      @deployed_at ||= ENV.key?('DEPLOYMENT_TIMESTAMP') ?
        Time.at(ENV['DEPLOYMENT_TIMESTAMP'].to_i) :
        booted_at
    end

    def call(env)
      [200, { 'Content-Type' => 'text/plain' }, ['OK']]
    end

    def configure(&block)
      block.call(self)
    end

    def pinglish
      @pinglish ||= Pinglish.new do |ping|
        ping.check(:host) { hostname }
        ping.check(:deployed_at) { deployed_at }
        ping.check(:revision) { revision }
        ping.check(:started_at) { booted_at }
      end
    end

    def check(*args, &block)
      pinglish.check(*args, &block)
    end
  end
end
