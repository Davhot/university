require 'test_helper'

class MainHotCatchLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @main_hot_catch_log = main_hot_catch_logs(:one)
  end

  test "should get index" do
    get main_hot_catch_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_main_hot_catch_log_url
    assert_response :success
  end

  test "should create main_hot_catch_log" do
    assert_difference('MainHotCatchLog.count') do
      post main_hot_catch_logs_url, params: { main_hot_catch_log: { count_log: @main_hot_catch_log.count_log, from_log: @main_hot_catch_log.from_log, id_log_origin_app: @main_hot_catch_log.id_log_origin_app, log_data: @main_hot_catch_log.log_data, name_app: @main_hot_catch_log.name_app } }
    end

    assert_redirected_to main_hot_catch_log_url(MainHotCatchLog.last)
  end

  test "should show main_hot_catch_log" do
    get main_hot_catch_log_url(@main_hot_catch_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_main_hot_catch_log_url(@main_hot_catch_log)
    assert_response :success
  end

  test "should update main_hot_catch_log" do
    patch main_hot_catch_log_url(@main_hot_catch_log), params: { main_hot_catch_log: { count_log: @main_hot_catch_log.count_log, from_log: @main_hot_catch_log.from_log, id_log_origin_app: @main_hot_catch_log.id_log_origin_app, log_data: @main_hot_catch_log.log_data, name_app: @main_hot_catch_log.name_app } }
    assert_redirected_to main_hot_catch_log_url(@main_hot_catch_log)
  end

  test "should destroy main_hot_catch_log" do
    assert_difference('MainHotCatchLog.count', -1) do
      delete main_hot_catch_log_url(@main_hot_catch_log)
    end

    assert_redirected_to main_hot_catch_logs_url
  end
end
