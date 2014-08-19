require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  test "health ping" do
    get '/health'
    assert_response :success
  end

  test "health status ping" do
    get '/health/status'
    status = JSON.parse(response.body)
    assert_response :success
    assert_equal status['app'], 'dummy'
  end

  test "health error ping" do
    assert_raises(RuntimeError) { get '/health/error' }
  end
end

