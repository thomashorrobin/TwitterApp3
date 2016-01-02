require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get addaccount" do
    get :addaccount
    assert_response :success
  end

end
