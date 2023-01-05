require "application_system_test_case"

class ParametersTest < ApplicationSystemTestCase
  setup do
    @parameter = parameters(:one)
  end

  test "visiting the index" do
    visit parameters_url
    assert_selector "h1", text: "Parameters"
  end

  test "should create parameter" do
    visit parameters_url
    click_on "New parameter"

    fill_in "Description", with: @parameter.description
    fill_in "Identifier", with: @parameter.identifier
    fill_in "Name", with: @parameter.name
    click_on "Create Parameter"

    assert_text "Parameter was successfully created"
    click_on "Back"
  end

  test "should update Parameter" do
    visit parameter_url(@parameter)
    click_on "Edit this parameter", match: :first

    fill_in "Description", with: @parameter.description
    fill_in "Identifier", with: @parameter.identifier
    fill_in "Name", with: @parameter.name
    click_on "Update Parameter"

    assert_text "Parameter was successfully updated"
    click_on "Back"
  end

  test "should destroy Parameter" do
    visit parameter_url(@parameter)
    click_on "Destroy this parameter", match: :first

    assert_text "Parameter was successfully destroyed"
  end
end
