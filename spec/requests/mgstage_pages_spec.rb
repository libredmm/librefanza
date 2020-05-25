require "rails_helper"

RSpec.describe "MgstagePages", type: :request do
  let(:page) { create(:mgstage_page) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /mgstage_pages" do
    it "works for admin" do
      get mgstage_pages_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get mgstage_pages_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /mgstage_pages/:id" do
    it "works for admin" do
      get mgstage_page_path(page, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get mgstage_page_path(page, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
