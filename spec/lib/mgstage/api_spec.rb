require "rails_helper"

RSpec.describe Mgstage::Api do
  describe "#search" do
    it "requests mgstage" do
      Mgstage::Api.search(generate(:normalized_id)) { next }
      expect(@mgstage_stub).to have_been_requested.at_least_once
    end

    it "requests all product page" do
      html_with_results = double(:html_with_results)
      a = double(:a)
      allow(html_with_results).to receive(:css).and_return([a])
      allow(a).to receive(:attr).and_return("/elsewhere")

      html_empty = double(:html_empty)
      allow(html_empty).to receive(:css).and_return([])

      expect(Nokogiri).to receive(:HTML).and_return(html_with_results, html_empty).at_least(:once)

      Mgstage::Api.search(generate(:normalized_id)) { next }
      expect(@mgstage_stub).to have_been_requested.at_least_twice
    end

    it "is no-op on fc2 ids" do
      Mgstage::Api.search(generate(:fc2_id)) { break }
      expect(@mgstage_stub).not_to have_been_requested
    end
  end
end
