require "rails_helper"

RSpec.describe "Movies", type: :request do
  let!(:fanza_item) { create(:fanza_item) }
  let!(:javlibrary_item) { create(:javlibrary_item) }

  describe "GET /movies" do
    it "works" do
      get movies_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /movie/:id" do
    it "works" do
      get movie_path(fanza_item.normalized_id)
      expect(response).to have_http_status(200)
    end

    it "searches fanza when needed" do
      get movie_path(javlibrary_item.normalized_id)
      expect(FanzaSearchJob).to have_been_enqueued.with(javlibrary_item.normalized_id)
      expect(JavlibrarySearchJob).not_to have_been_enqueued
    end

    it "also searches javlibrary when needed" do
      id = generate(:normalized_id)
      get movie_path(id)
      expect(FanzaSearchJob).to have_been_enqueued.with(id)
      expect(JavlibrarySearchJob).to have_been_enqueued.with(id)
    end
  end
end
