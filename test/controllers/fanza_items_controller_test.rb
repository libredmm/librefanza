require 'test_helper'

class FanzaItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fanza_item = fanza_items(:one)
  end

  test "should get index" do
    get fanza_items_url
    assert_response :success
  end

  test "should get new" do
    get new_fanza_item_url
    assert_response :success
  end

  test "should create fanza_item" do
    assert_difference('FanzaItem.count') do
      post fanza_items_url, params: { fanza_item: { content_id: @fanza_item.content_id, raw_json: @fanza_item.raw_json } }
    end

    assert_redirected_to fanza_item_url(FanzaItem.last)
  end

  test "should show fanza_item" do
    get fanza_item_url(@fanza_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_fanza_item_url(@fanza_item)
    assert_response :success
  end

  test "should update fanza_item" do
    patch fanza_item_url(@fanza_item), params: { fanza_item: { content_id: @fanza_item.content_id, raw_json: @fanza_item.raw_json } }
    assert_redirected_to fanza_item_url(@fanza_item)
  end

  test "should destroy fanza_item" do
    assert_difference('FanzaItem.count', -1) do
      delete fanza_item_url(@fanza_item)
    end

    assert_redirected_to fanza_items_url
  end
end
