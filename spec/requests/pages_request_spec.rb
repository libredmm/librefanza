require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /search" do
    it "redirects to movie page" do
      get search_path(q: "ABP-123")
      expect(response).to redirect_to(movie_path("ABP-123"))
    end
  end
end
