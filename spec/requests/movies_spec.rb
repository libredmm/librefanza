require "rails_helper"

RSpec.describe "Movies", type: :request do
  let(:movie) { create :movie }

  describe "GET /movies" do
    it "works" do
      get movies_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /movie/:id" do
    it "works" do
      get movie_path(movie)
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
      get movie_path(movie, format: :json)
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

  context "when hidden" do
    let(:hidden_movie) { create :movie, is_hidden: true }

    describe "GET /movie/:id" do
      it "returns not found" do
        get movie_path(hidden_movie)
        expect(response).to have_http_status(404)
      end
    end

    describe "GET /movie/:id.json" do
      it "works" do
        get movie_path(hidden_movie, format: :json)
        expect(response).to have_http_status(200)
      end
    end
  end
end
