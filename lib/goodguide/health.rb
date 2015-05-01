require 'forwardable'
require 'rack/builder'
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
          run health
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
      @hostname = `hostname`.chomp
      @booted_at = Time.now
      @deployed_at = @booted_at
      @revision = `git rev-parse HEAD`.chomp
    end

    attr_accessor :revision, :deployed_at
    attr_reader :hostname, :booted_at

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
