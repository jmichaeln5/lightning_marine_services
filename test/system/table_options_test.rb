require "application_system_test_case"

class TableOptionsTest < ApplicationSystemTestCase
  setup do
    @table_option = table_options(:one)
  end

  test "visiting the index" do
    visit table_options_url
    assert_selector "h1", text: "Table Options"
  end

  test "creating a Table option" do
    visit table_options_url
    click_on "New Table Option"

    fill_in "Option list", with: @table_option.option_list
    fill_in "Resource table type", with: @table_option.resource_table_type
    fill_in "User", with: @table_option.user_id
    click_on "Create Table option"

    assert_text "Table option was successfully created"
    click_on "Back"
  end

  test "updating a Table option" do
    visit table_options_url
    click_on "Edit", match: :first

    fill_in "Option list", with: @table_option.option_list
    fill_in "Resource table type", with: @table_option.resource_table_type
    fill_in "User", with: @table_option.user_id
    click_on "Update Table option"

    assert_text "Table option was successfully updated"
    click_on "Back"
  end

  test "destroying a Table option" do
    visit table_options_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Table option was successfully destroyed"
  end
end
