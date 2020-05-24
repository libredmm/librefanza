require "rails_helper"

RSpec.describe FanzaItem, type: :model do
  it_behaves_like "generic item" do
    let(:item) { create :fanza_item }
  end

  let(:item) { create :fanza_item }

  %i[floor_code].each do |key|
    it "has #{key}" do
      expect(item.send(key)).to be_present
    end
  end

  describe ".actresses" do
    it "return empty array when no provided" do
      expect {
        item.raw_json["iteminfo"].delete("actress")
      }.to change {
        item.actresses
      }.to([])
    end
  end

  describe ".as_json" do
    it "filters out affiliate urls" do
      expect(item.as_json).not_to include("affiliateURL")
      expect(item.as_json).not_to include("affiliateURLsp")
    end
  end
end
