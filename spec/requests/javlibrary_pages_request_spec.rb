require "rails_helper"

RSpec.describe "JavlibraryPages", type: :request do
  let!(:page) { create(:javlibrary_product_page) }

  describe "GET /javlibrary_pages" do
    it "works" do
      get javlibrary_pages_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /javlibrary_pages/:id" do
    it "works" do
      get javlibrary_page_path(page)
      expect(response).to have_http_status(200)
    end
  end
end
