require "test_helper"

class DirectoryLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @directory_link = directory_links(:one)
  end

  test "should get index" do
    get directory_links_url
    assert_response :success
  end

  test "should get new" do
    get new_directory_link_url
    assert_response :success
  end

  test "should create directory_link" do
    assert_difference('DirectoryLink.count') do
      post directory_links_url, params: { directory_link: { desc: @directory_link.desc, info: @directory_link.info, title: @directory_link.title } }
    end

    assert_redirected_to directory_link_url(DirectoryLink.last)
  end

  test "should show directory_link" do
    get directory_link_url(@directory_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_directory_link_url(@directory_link)
    assert_response :success
  end

  test "should update directory_link" do
    patch directory_link_url(@directory_link), params: { directory_link: { desc: @directory_link.desc, info: @directory_link.info, title: @directory_link.title } }
    assert_redirected_to directory_link_url(@directory_link)
  end

  test "should destroy directory_link" do
    assert_difference('DirectoryLink.count', -1) do
      delete directory_link_url(@directory_link)
    end

    assert_redirected_to directory_links_url
  end
end
