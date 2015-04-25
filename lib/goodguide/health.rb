require 'singleton'
require 'forwardable'
require 'rack/builder'
require 'pinglish'
require 'goodguide/health/version'

module Goodguide
  class Health
    include Singleton

    class <<self
      extend Forwardable

      def_delegator :instance, :configure

      def app
        health = instance
        Rack::Builder.app do
          map '/status' do
            run health.pinglish
          end
          run health
        end
      end

      # to avoid confusion, hide the instance accessor since .app should be the
      # only exposed means of access
      private :instance
    end

    def initialize
      @hostname = `hostname`.chomp
      # The CODE_DEPLOYMENT_TIMESTAMP and CODE_REVISION constants are sometimes
      # made available in deployment via an initializer written by goodguide-deploy
      @revision = defined?(CODE_REVISION) ? CODE_REVISION : `git rev-parse HEAD`.chomp
      @booted_at = Time.now
      @deployed_at = defined?(CODE_DEPLOYMENT_TIMESTAMP) ? Time.at(CODE_DEPLOYMENT_TIMESTAMP) : @booted_at
    end

    attr_reader :revision, :deployed_at, :hostname, :booted_at

    def call(env)
      [200, {}, ['OK']]
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
