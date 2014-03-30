require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
