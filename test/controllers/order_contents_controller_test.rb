require "test_helper"

class OrderContentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order_content = order_contents(:one)
  end

  test "should get index" do
    get order_contents_url
    assert_response :success
  end

  test "should get new" do
    get new_order_content_url
    assert_response :success
  end

  test "should create order_content" do
    assert_difference('OrderContent.count') do
      post order_contents_url, params: { order_content: { box: @order_content.box, crate: @order_content.crate, order_id: @order_content.order_id, other: @order_content.other, other_description: @order_content.other_description, pallet: @order_content.pallet } }
    end

    assert_redirected_to order_content_url(OrderContent.last)
  end

  test "should show order_content" do
    get order_content_url(@order_content)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_content_url(@order_content)
    assert_response :success
  end

  test "should update order_content" do
    patch order_content_url(@order_content), params: { order_content: { box: @order_content.box, crate: @order_content.crate, order_id: @order_content.order_id, other: @order_content.other, other_description: @order_content.other_description, pallet: @order_content.pallet } }
    assert_redirected_to order_content_url(@order_content)
  end

  test "should destroy order_content" do
    assert_difference('OrderContent.count', -1) do
      delete order_content_url(@order_content)
    end

    assert_redirected_to order_contents_url
  end
end
