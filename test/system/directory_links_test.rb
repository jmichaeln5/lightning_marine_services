require "application_system_test_case"

class DirectoryLinksTest < ApplicationSystemTestCase
  setup do
    @directory_link = directory_links(:one)
  end

  test "visiting the index" do
    visit directory_links_url
    assert_selector "h1", text: "Directory Links"
  end

  test "creating a Directory link" do
    visit directory_links_url
    click_on "New Directory Link"

    fill_in "Desc", with: @directory_link.desc
    fill_in "Info", with: @directory_link.info
    fill_in "Title", with: @directory_link.title
    click_on "Create Directory link"

    assert_text "Directory link was successfully created"
    click_on "Back"
  end

  test "updating a Directory link" do
    visit directory_links_url
    click_on "Edit", match: :first

    fill_in "Desc", with: @directory_link.desc
    fill_in "Info", with: @directory_link.info
    fill_in "Title", with: @directory_link.title
    click_on "Update Directory link"

    assert_text "Directory link was successfully updated"
    click_on "Back"
  end

  test "destroying a Directory link" do
    visit directory_links_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Directory link was successfully destroyed"
  end
end
