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

    it "performs search when needed" do
      id = generate :normalized_id
      get movie_path(id)
      expect(response).to have_http_status(404)
      expect(MovieSearcher).to have_enqueued_sidekiq_job(id)
    end
  end

  describe "GET /movie/:id.json" do
    it "works" do
      get movie_path(fanza_item.normalized_id, format: :json)
      expect(response).to have_http_status(200)
    end

    it "returns accepted when search triggered" do
      id = generate :normalized_id
      get movie_path(id, format: :json)
      expect(response).to have_http_status(202)
    end

    it "returns not found when not found" do
      id = generate :normalized_id
      expect(MovieSearcher).to receive(:perform_async).and_return(nil)
      get movie_path(id, format: :json)
      expect(response).to have_http_status(404)
    end
  end
end
