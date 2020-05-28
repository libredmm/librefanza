require "rails_helper"

RSpec.describe Fanza::Api do
  describe "#search" do
    it "delegates to item_list" do
      id = generate :normalized_id
      expect(Fanza::Api).to receive(:item_list).at_least(:twice)
      Fanza::Api.search(id) { next }
    end
  end

  describe "#item_list" do
    it "calls fanza lazily" do
      Fanza::Api.item_list(generate(:normalized_id)) { break }
      expect(@item_list_stub).to have_been_requested
    end

    it "keeps calling until all results fetched" do
      Fanza::Api.item_list(generate(:normalized_id)) { next }
      expect(@item_list_stub).to have_been_requested.times(40)
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
