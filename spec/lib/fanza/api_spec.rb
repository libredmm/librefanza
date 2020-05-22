require "rails_helper"

RSpec.describe "Fanza::Api" do
  describe "#item_list" do
    it "calls fanza" do
      Fanza::Api.item_list generate(:normalized_id)
      expect(@item_list_stub).to have_been_requested.times(10)
    end
  end

  describe "#actress_search" do
    it "keeps calling fanza util all results fetchs" do
      Fanza::Api.actress_search
      expect(@actress_search_stub).to have_been_requested.times(10)
    end
  end
end
