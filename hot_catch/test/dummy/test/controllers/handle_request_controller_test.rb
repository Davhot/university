require 'test_helper'

class HandleRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get handle_request_start_url
    assert_response :success
  end

end
