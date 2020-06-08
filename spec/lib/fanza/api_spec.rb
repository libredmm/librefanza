require "rails_helper"

RSpec.describe Fanza::Api do
  describe "#search" do
    it "calls fanza lazily" do
      Fanza::Api.search(keyword: generate(:normalized_id)) { break }
      expect(@item_list_stub).to have_been_requested
    end

    it "keeps calling until all results fetched" do
      Fanza::Api.search(keyword: generate(:normalized_id)) { next }
      expect(@item_list_stub).to have_been_requested.at_least_times(10)
    end
  end

  describe "#actress_search" do
    it "calls fanza lazily" do
      Fanza::Api.actress_search { break }
      expect(@actress_search_stub).to have_been_requested
    end

    it "keeps calling until all results fetched" do
      Fanza::Api.actress_search { next }
      expect(@actress_search_stub).to have_been_requested.times(5)
    end
  end
end
