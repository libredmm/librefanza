require "rails_helper"

RSpec.describe "Fc2Pages", type: :request do
  let(:page) { create(:fc2_page) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /fc2_pages" do
    it "works for admin" do
      get fc2_pages_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get fc2_pages_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /fc2_pages/:id" do
    it "works for admin" do
      get fc2_page_path(page, as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get fc2_page_path(page, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
