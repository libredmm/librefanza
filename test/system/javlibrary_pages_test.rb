require "application_system_test_case"

class JavlibraryPagesTest < ApplicationSystemTestCase
  setup do
    @javlibrary_page = javlibrary_pages(:one)
  end

  test "visiting the index" do
    visit javlibrary_pages_url
    assert_selector "h1", text: "Javlibrary Pages"
  end

  test "creating a Javlibrary page" do
    visit javlibrary_pages_url
    click_on "New Javlibrary Page"

    fill_in "Raw html", with: @javlibrary_page.raw_html
    fill_in "Url", with: @javlibrary_page.url
    click_on "Create Javlibrary page"

    assert_text "Javlibrary page was successfully created"
    click_on "Back"
  end

  test "updating a Javlibrary page" do
    visit javlibrary_pages_url
    click_on "Edit", match: :first

    fill_in "Raw html", with: @javlibrary_page.raw_html
    fill_in "Url", with: @javlibrary_page.url
    click_on "Update Javlibrary page"

    assert_text "Javlibrary page was successfully updated"
    click_on "Back"
  end

  test "destroying a Javlibrary page" do
    visit javlibrary_pages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Javlibrary page was successfully destroyed"
  end
end
