require 'test_helper'

class JavlibraryPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @javlibrary_page = javlibrary_pages(:one)
  end

  test "should get index" do
    get javlibrary_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_javlibrary_page_url
    assert_response :success
  end

  test "should create javlibrary_page" do
    assert_difference('JavlibraryPage.count') do
      post javlibrary_pages_url, params: { javlibrary_page: { raw_html: @javlibrary_page.raw_html, url: @javlibrary_page.url } }
    end

    assert_redirected_to javlibrary_page_url(JavlibraryPage.last)
  end

  test "should show javlibrary_page" do
    get javlibrary_page_url(@javlibrary_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_javlibrary_page_url(@javlibrary_page)
    assert_response :success
  end

  test "should update javlibrary_page" do
    patch javlibrary_page_url(@javlibrary_page), params: { javlibrary_page: { raw_html: @javlibrary_page.raw_html, url: @javlibrary_page.url } }
    assert_redirected_to javlibrary_page_url(@javlibrary_page)
  end

  test "should destroy javlibrary_page" do
    assert_difference('JavlibraryPage.count', -1) do
      delete javlibrary_page_url(@javlibrary_page)
    end

    assert_redirected_to javlibrary_pages_url
  end
end
