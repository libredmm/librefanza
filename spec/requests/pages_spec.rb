require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /search" do
    context "for normalizable query" do
      it "redirects to normalized movie page" do
        get search_path(q: "abc123")
        expect(response).to redirect_to(movie_path("ABC-123"))
      end
    end

    context "for un-normalizable query" do
      it "redirects to fuzzy search movie page" do
        get search_path(q: "abC")
        expect(response).to redirect_to(movies_path(fuzzy: "abC", commit: "Prefix"))
      end
    end
  end
end
