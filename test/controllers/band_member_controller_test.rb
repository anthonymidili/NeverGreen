require 'test_helper'

class BandMemberControllerTest < ActionDispatch::IntegrationTest
  test "should get directory" do
    get band_members_directory_url
    assert_response :success
  end

end
