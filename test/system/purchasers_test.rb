require "application_system_test_case"

class PurchasersTest < ApplicationSystemTestCase
  setup do
    @purchaser = purchasers(:one)
  end

  test "visiting the index" do
    visit purchasers_url
    assert_selector "h1", text: "Purchasers"
  end

  test "creating a Purchaser" do
    visit purchasers_url
    click_on "New Purchaser"

    fill_in "Name", with: @purchaser.name
    fill_in "User", with: @purchaser.user_id
    click_on "Create Purchaser"

    assert_text "Purchaser was successfully created"
    click_on "Back"
  end

  test "updating a Purchaser" do
    visit purchasers_url
    click_on "Edit", match: :first

    fill_in "Name", with: @purchaser.name
    fill_in "User", with: @purchaser.user_id
    click_on "Update Purchaser"

    assert_text "Purchaser was successfully updated"
    click_on "Back"
  end

  test "destroying a Purchaser" do
    visit purchasers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Purchaser was successfully destroyed"
  end
end
