require "rails_helper"

RSpec.describe "SodItems", type: :request do
  let(:item) { create(:sod_item) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /sod_items" do
    it "works for admin" do
      get sod_items_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get sod_items_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /sod_items/:id" do
    it "works" do
      get sod_item_path(item, as: user)
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /sod_items/:id" do
    it "works for admin" do
      delete sod_item_path(item, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        delete sod_item_path(item, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
