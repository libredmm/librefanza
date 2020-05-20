require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /godmode" do
    it "toggles godmode on/off" do
      get godmode_path
      expect(response.cookies["whosyourdaddy"]).to be_present
      get godmode_path
      expect(response.cookies["whosyourdaddy"]).not_to be_present
    end
  end

  describe "GET /search" do
    it "redirects to movie page" do
      get search_path(q: "ABP-123")
      expect(response).to redirect_to(movie_path("ABP-123"))
    end
  end
end
