require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get sample_route" do
    get sample_route_url
    assert_response :success
  end

end
