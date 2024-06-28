require "rails_helper"

RSpec.describe Fc2::Api do
  describe "#search" do
    it "requests fc2" do
      Fc2::Api.search(generate(:fc2_id)) { next }
      expect(@fc2_stub).to have_been_requested.at_least_once
    end

    it "is no-op on non-fc2 ids" do
      Fc2::Api.search(generate(:normalized_id)) { break }
      expect(@fc2_stub).not_to have_been_requested
    end
  end
end
