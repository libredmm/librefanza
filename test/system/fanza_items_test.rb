require "application_system_test_case"

class FanzaItemsTest < ApplicationSystemTestCase
  setup do
    @fanza_item = fanza_items(:one)
  end

  test "visiting the index" do
    visit fanza_items_url
    assert_selector "h1", text: "Fanza Items"
  end

  test "creating a Fanza item" do
    visit fanza_items_url
    click_on "New Fanza Item"

    fill_in "Content", with: @fanza_item.content_id
    fill_in "Raw json", with: @fanza_item.raw_json
    click_on "Create Fanza item"

    assert_text "Fanza item was successfully created"
    click_on "Back"
  end

  test "updating a Fanza item" do
    visit fanza_items_url
    click_on "Edit", match: :first

    fill_in "Content", with: @fanza_item.content_id
    fill_in "Raw json", with: @fanza_item.raw_json
    click_on "Update Fanza item"

    assert_text "Fanza item was successfully updated"
    click_on "Back"
  end

  test "destroying a Fanza item" do
    visit fanza_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fanza item was successfully destroyed"
  end
end
