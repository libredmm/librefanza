require "rails_helper"

RSpec.describe "MgstageItem", type: :request do
  let(:item) { create(:mgstage_item) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /mgstage_items" do
    it "works for admin" do
      get mgstage_items_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get mgstage_items_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /mgstage_items/:id" do
    it "works" do
      get mgstage_item_path(item, as: user)
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /mgstage_items/:id" do
    it "works for admin" do
      delete mgstage_item_path(item, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        delete mgstage_item_path(item, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
