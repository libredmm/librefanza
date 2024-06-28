require "rails_helper"

RSpec.describe "Fc2Items", type: :request do
  let(:item) { create(:fc2_item) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /fc2_items" do
    it "works for admin" do
      get fc2_items_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get fc2_items_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /fc2_items/:id" do
    it "works" do
      get fc2_item_path(item, as: user)
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /fc2_items/:id" do
    it "works for admin" do
      delete fc2_item_path(item, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        delete fc2_item_path(item, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
