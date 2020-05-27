require "rails_helper"

RSpec.describe "JavlibraryItems", type: :request do
  let(:item) { create(:javlibrary_item) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /javlibrary_items" do
    it "works for admin" do
      get javlibrary_items_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get javlibrary_items_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /javlibrary_items/:id" do
    it "works as admin" do
      get javlibrary_item_path(item, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get javlibrary_item_path(item, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "DELETE /javlibrary_items/:id" do
    it "works as admin" do
      delete javlibrary_item_path(item, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        delete javlibrary_item_path(item, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
