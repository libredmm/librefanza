require 'test_helper'

class JavlibraryItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @javlibrary_item = javlibrary_items(:one)
  end

  test "should get index" do
    get javlibrary_items_url
    assert_response :success
  end

  test "should get new" do
    get new_javlibrary_item_url
    assert_response :success
  end

  test "should create javlibrary_item" do
    assert_difference('JavlibraryItem.count') do
      post javlibrary_items_url, params: { javlibrary_item: { javlibrary_page_id: @javlibrary_item.javlibrary_page_id, normalized_id: @javlibrary_item.normalized_id } }
    end

    assert_redirected_to javlibrary_item_url(JavlibraryItem.last)
  end

  test "should show javlibrary_item" do
    get javlibrary_item_url(@javlibrary_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_javlibrary_item_url(@javlibrary_item)
    assert_response :success
  end

  test "should update javlibrary_item" do
    patch javlibrary_item_url(@javlibrary_item), params: { javlibrary_item: { javlibrary_page_id: @javlibrary_item.javlibrary_page_id, normalized_id: @javlibrary_item.normalized_id } }
    assert_redirected_to javlibrary_item_url(@javlibrary_item)
  end

  test "should destroy javlibrary_item" do
    assert_difference('JavlibraryItem.count', -1) do
      delete javlibrary_item_url(@javlibrary_item)
    end

    assert_redirected_to javlibrary_items_url
  end
end
