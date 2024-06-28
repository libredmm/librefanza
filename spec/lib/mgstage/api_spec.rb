require "rails_helper"

RSpec.describe Mgstage::Api do
  describe "#search" do
    it "requests mgstage" do
      Mgstage::Api.search(generate(:normalized_id)) { next }
      expect(@mgstage_stub).to have_been_requested.at_least_once
    end

    it "requests all product page" do
      html = double(:html)
      expect(Nokogiri).to receive(:HTML).and_return(html).at_least(:once)
      a = double(:a)
      expect(html).to receive(:css).and_return([a]).at_least(:once)
      url = "/elsewhere"
      expect(a).to receive(:attr).and_return(url).at_least(:once)

      Mgstage::Api.search(generate(:normalized_id)) { next }
      expect(@mgstage_stub).to have_been_requested.at_least_twice
    end

    it "is no-op on fc2 ids" do
      Mgstage::Api.search(generate(:fc2_id)) { break }
      expect(@mgstage_stub).not_to have_been_requested
    end
  end
end
