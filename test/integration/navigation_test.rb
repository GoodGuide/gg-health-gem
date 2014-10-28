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

  test "maintenance mode enabled" do
    Goodguide::Health::Maintenance.instance.enable!('custom message')
    get '/health/maintenance'
    status = JSON.parse(response.body)
    assert_response :success
    assert_equal status, { 'maintenance' => true, 'message' => 'custom message' }
  end

  test "maintenance mode disabled" do
    Goodguide::Health::Maintenance.instance.disable!
    get '/health/maintenance'
    status = JSON.parse(response.body)
    assert_response :success
    assert_equal status, { 'maintenance' => false }
  end
end

