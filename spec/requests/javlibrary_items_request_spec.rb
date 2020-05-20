require "rails_helper"

RSpec.describe "JavlibraryItems", type: :request do
  let!(:item) { create(:javlibrary_item) }

  describe "GET /javlibrary_items" do
    it "works" do
      get javlibrary_items_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /javlibrary_items/:id" do
    it "works" do
      get javlibrary_item_path(item)
      expect(response).to have_http_status(200)
    end
  end
end
