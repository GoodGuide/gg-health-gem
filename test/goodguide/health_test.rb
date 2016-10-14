require 'test_helper'
require 'timecop'

class Goodguide::HealthTest < Minitest::Test
  include Rack::Test::Methods

  def app_boot_time
    Time.at(1430161200)
  end

  attr_reader :app

  def setup
    Goodguide::Health.reset
    Timecop.freeze(app_boot_time) do
      # force initialization of the instance with time frozen
      @app = Goodguide::Health.app
    end
    Timecop.freeze(Time.now)
  end

  def teardown
    Timecop.return
  end

  def test_root_path
    get '/'

    assert last_response.ok?
    assert_equal "OK\n", last_response.body
  end

  def test_status_default
    get '/status'

    assert last_response.ok?
    assert_status_response_matches parsed_response, default_status_response
  end

  def test_status_termination
    get '/status'

    assert last_response.ok?
    assert last_response.body.end_with?("\n"), 'Output should end with an ASCII newline char'
  end

  def test_status_with_deployment_info
    timestamp = 1430162520
    Goodguide::Health.configure do |health|
      health.revision = 'foo'
      health.deployed_at = Time.at(timestamp).utc
    end
    get '/status'

    assert last_response.ok?
    assert_status_response_matches parsed_response, default_status_response.merge(
      deployed_at: Time.at(timestamp).utc.iso8601,
      revision: 'foo'
    )
  end

  def test_status_with_gg_env
    Goodguide::Health.configure do |health|
      health.gg_env = 'production'
    end
    get '/status'

    assert last_response.ok?
    assert_status_response_matches parsed_response, default_status_response.merge(gg_env: 'production')
  end

  def test_status_with_custom_checks
    Goodguide::Health.configure do |health|
      health.check :custom_check do
        :foobarbaz
      end
    end
    get '/status'

    assert last_response.ok?
    assert_status_response_matches parsed_response, default_status_response.merge(
      custom_check: 'foobarbaz'
    )
  end

  def test_status_with_custom_checks_which_fail
    Goodguide::Health.configure do |health|
      health.check :custom_check_that_fails do
        raise "foo"
      end
    end
    get '/status'

    assert_equal 503, last_response.status
    assert_status_response_matches parsed_response, default_status_response.merge(
      status: 'failures',
      failures: ['custom_check_that_fails'],
      custom_check_that_fails: {
        'state' => 'error',
        'exception' => 'RuntimeError',
        'message' => 'foo',
      }
    )
  end

  def test_status_with_custom_checks_which_timeout
    Goodguide::Health.configure do |health|
      health.check :custom_check_that_times_out, timeout: 0.01 do
        sleep 1
      end
    end
    get '/status'

    assert_equal 503, last_response.status
    assert_status_response_matches parsed_response, default_status_response.merge(
      status: 'failures',
      timeouts: ['custom_check_that_times_out'],
    )
  end

  def test_status_with_subset_of_checks
    Goodguide::Health.configure do |health|
      health.check :custom_check_that_times_out, timeout: 0.01 do
        sleep 1
      end

      health.check :foobar do
        123
      end
    end
    get '/status?checks=foobar'

    assert_equal 200, last_response.status
    assert_status_response_matches parsed_response, {
      status: 'ok',
      now: Time.now.to_i,
      foobar: 123,
    }
  end

  private

  def git_revision
    `git rev-parse HEAD`.chomp
  end

  def parsed_response
    JSON.parse(last_response.body)
  end

  def default_status_response
    {
      status: 'ok',
      now: Time.now.utc.to_i,
      deployed_at: app_boot_time.utc.iso8601,
      started_at: app_boot_time.utc.iso8601,
      host: `hostname`.chomp,
      revision: git_revision,
    }
  end

  def assert_status_response_matches(actual, expected)
    expected.each do |key, value|
      assert_equal value, actual[key.to_s], "value for `#{key}` did not match"
    end
    assert_equal expected.keys.map(&:to_s).sort, actual.keys.sort, "keys did not match"
  end
end
