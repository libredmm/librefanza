require "rails_helper"

RSpec.describe Mgstage::Api do
  describe "#search" do
    it "requests mgstage" do
      Mgstage::Api.search(generate(:normalized_id)) { next }
      expect(@mgstage_stub).to have_been_requested
    end

    it "requests all product page" do
      html = double(:html)
      expect(Nokogiri).to receive(:HTML).and_return(html)
      a = double(:a)
      expect(html).to receive(:css).and_return([a])
      url = generate :url
      expect(a).to receive(:attr).and_return(url)

      Mgstage::Api.search(generate(:normalized_id)) { next }
      expect(@mgstage_stub).to have_been_requested.twice
    end
  end
end
