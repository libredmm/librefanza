require "rails_helper"

RSpec.describe "FanzaItems", type: :request do
  let!(:item) { create(:fanza_item) }

  describe "GET /fanza_items" do
    it "works" do
      get fanza_items_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /fanza_item/:id" do
    it "works" do
      get fanza_item_path(item)
      expect(response).to have_http_status(200)
    end
  end
end
