require "rails_helper"

RSpec.describe "FanzaItems", type: :request do
  let(:item) { create(:fanza_item) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /fanza_items" do
    it "works for admin" do
      get fanza_items_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get fanza_items_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /fanza_items/:id" do
    it "works for admin" do
      get fanza_item_path(item, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get fanza_item_path(item, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "DELETE /fanza_items/:id" do
    it "works for admin" do
      delete fanza_item_path(item, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        delete fanza_item_path(item, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
