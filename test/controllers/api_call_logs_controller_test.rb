require 'test_helper'

class ApiCallLogsControllerTest < ActionController::TestCase
  setup do
    @api_call_log = api_call_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_call_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_call_log" do
    assert_difference('ApiCallLog.count') do
      post :create, api_call_log: { calldatetime: @api_call_log.calldatetime, calldescription: @api_call_log.calldescription, successful: @api_call_log.successful }
    end

    assert_redirected_to api_call_log_path(assigns(:api_call_log))
  end

  test "should show api_call_log" do
    get :show, id: @api_call_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_call_log
    assert_response :success
  end

  test "should update api_call_log" do
    patch :update, id: @api_call_log, api_call_log: { calldatetime: @api_call_log.calldatetime, calldescription: @api_call_log.calldescription, successful: @api_call_log.successful }
    assert_redirected_to api_call_log_path(assigns(:api_call_log))
  end

  test "should destroy api_call_log" do
    assert_difference('ApiCallLog.count', -1) do
      delete :destroy, id: @api_call_log
    end

    assert_redirected_to api_call_logs_path
  end
end
