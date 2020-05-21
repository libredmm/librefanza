require "rails_helper"

RSpec.describe "Fanza::Api" do
  describe "#item_list" do
    it "calls fanza" do
      Fanza::Api.item_list generate(:normalized_id)
      expect(@item_list_stub).to have_been_requested
    end
  end
end
