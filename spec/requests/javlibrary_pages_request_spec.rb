require "rails_helper"

RSpec.describe "JavlibraryPages", type: :request do
  let(:page) { create(:javlibrary_product_page) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /javlibrary_pages" do
    it "works for admin" do
      get javlibrary_pages_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get javlibrary_pages_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /javlibrary_pages/:id" do
    it "works for admin" do
      get javlibrary_page_path(page, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get javlibrary_page_path(page, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
