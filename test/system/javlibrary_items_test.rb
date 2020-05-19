require "application_system_test_case"

class JavlibraryItemsTest < ApplicationSystemTestCase
  setup do
    @javlibrary_item = javlibrary_items(:one)
  end

  test "visiting the index" do
    visit javlibrary_items_url
    assert_selector "h1", text: "Javlibrary Items"
  end

  test "creating a Javlibrary item" do
    visit javlibrary_items_url
    click_on "New Javlibrary Item"

    fill_in "Javlibrary page", with: @javlibrary_item.javlibrary_page_id
    fill_in "Normalized", with: @javlibrary_item.normalized_id
    click_on "Create Javlibrary item"

    assert_text "Javlibrary item was successfully created"
    click_on "Back"
  end

  test "updating a Javlibrary item" do
    visit javlibrary_items_url
    click_on "Edit", match: :first

    fill_in "Javlibrary page", with: @javlibrary_item.javlibrary_page_id
    fill_in "Normalized", with: @javlibrary_item.normalized_id
    click_on "Update Javlibrary item"

    assert_text "Javlibrary item was successfully updated"
    click_on "Back"
  end

  test "destroying a Javlibrary item" do
    visit javlibrary_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Javlibrary item was successfully destroyed"
  end
end
