require "test_helper"

class TableOptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @table_option = table_options(:one)
  end

  test "should get index" do
    get table_options_url
    assert_response :success
  end

  test "should get new" do
    get new_table_option_url
    assert_response :success
  end

  test "should create table_option" do
    assert_difference('TableOption.count') do
      post table_options_url, params: { table_option: { option_list: @table_option.option_list, resource_table_type: @table_option.resource_table_type, user_id: @table_option.user_id } }
    end

    assert_redirected_to table_option_url(TableOption.last)
  end

  test "should show table_option" do
    get table_option_url(@table_option)
    assert_response :success
  end

  test "should get edit" do
    get edit_table_option_url(@table_option)
    assert_response :success
  end

  test "should update table_option" do
    patch table_option_url(@table_option), params: { table_option: { option_list: @table_option.option_list, resource_table_type: @table_option.resource_table_type, user_id: @table_option.user_id } }
    assert_redirected_to table_option_url(@table_option)
  end

  test "should destroy table_option" do
    assert_difference('TableOption.count', -1) do
      delete table_option_url(@table_option)
    end

    assert_redirected_to table_options_url
  end
end
