require "rails_helper"

RSpec.describe Sod::Api do
  describe "#search" do
    it "requests sod" do
      Sod::Api.search(generate(:normalized_id)) { next }
      expect(@sod_stub).to have_been_requested.at_least_once
    end

    it "is no-op on fc2 ids" do
      Sod::Api.search(generate(:fc2_id)) { break }
      expect(@sod_stub).not_to have_been_requested
    end
  end
end
