require "rails_helper"

RSpec.describe "JavlibraryPages", type: :request do
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
    let(:page) { create(:javlibrary_product_page) }

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

  describe "GET /javlibrary_pages/new" do
    it "works for admin" do
      get new_javlibrary_page_path(as: admin)
      expect(response).to have_http_status(200)
    end

    it "rejects other users" do
      expect {
        get new_javlibrary_page_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "POST /javlibrary_pages/" do
    it "rejects non admins" do
      expect {
        post javlibrary_pages_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end

    describe "with invalid params" do
      it "renders form with errors" do
        post javlibrary_pages_path(
          javlibrary_page: { url: "", raw_html: "" },
          as: admin,
        )
        expect(response.body).to include("invalid-feedback")
      end
    end

    describe "when page contains item" do
      it "redirect to item" do
        attrs = attributes_for(:javlibrary_product_page)
        post javlibrary_pages_path(javlibrary_page: attrs, as: admin)
        page = JavlibraryPage.find_by(url: attrs[:url])
        expect(response).to redirect_to(page.javlibrary_item)
      end
    end

    describe "when page does not contain item" do
      it "redirect to item" do
        url = generate :url
        post javlibrary_pages_path(
          javlibrary_page: {
            url: url,
            raw_html: "<html></html>",
          },
          as: admin,
        )
        page = JavlibraryPage.find_by(url: url)
        expect(response).to redirect_to(page)
      end
    end
  end
end
