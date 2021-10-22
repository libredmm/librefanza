require "rails_helper"

RSpec.describe "SodPages", type: :request do
  let(:page) { create(:sod_page) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /sod_pages" do
    it "works for admin" do
      get sod_pages_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get sod_pages_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /sod_pages/:id" do
    it "works for admin" do
      get sod_page_path(page, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get sod_page_path(page, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
