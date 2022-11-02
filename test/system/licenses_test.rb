require "application_system_test_case"

class LicensesTest < ApplicationSystemTestCase
  setup do
    @license = licenses(:one)
  end

  test "visiting the index" do
    visit licenses_url
    assert_selector "h1", text: "Licenses"
  end

  test "should create license" do
    visit licenses_url
    click_on "New license"

    fill_in "Key", with: @license.key
    fill_in "Status", with: @license.status
    click_on "Create License"

    assert_text "License was successfully created"
    click_on "Back"
  end

  test "should update License" do
    visit license_url(@license)
    click_on "Edit this license", match: :first

    fill_in "Key", with: @license.key
    fill_in "Status", with: @license.status
    click_on "Update License"

    assert_text "License was successfully updated"
    click_on "Back"
  end

  test "should destroy License" do
    visit license_url(@license)
    click_on "Destroy this license", match: :first

    assert_text "License was successfully destroyed"
  end
end
