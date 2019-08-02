require 'test_helper'

class TimezonesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get timezones_edit_url
    assert_response :success
  end

end
