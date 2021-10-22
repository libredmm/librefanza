require "rails_helper"

RSpec.describe FanzaItem, type: :model do
  subject { create :fanza_item }

  it_behaves_like "generic item"

  %i[floor_code].each do |key|
    it "has #{key}" do
      expect(subject.send(key)).to be_present
    end
  end

  it "falls back to maker product when content id can not be normalized" do
    expect {
      subject.raw_json["content_id"] = "123abc"
      subject.raw_json["maker_product"] = "MAKER-123"
      subject.derive_fields
      subject.save
    }.to change {
      subject.normalized_id
    }.to("MAKER-123")
  end

  describe "derive_fields" do
    it "works with invalid url" do
      allow(subject).to receive(:url).and_return("http://bad.url/")
      subject.derive_fields
    end
  end

  describe ".actresses" do
    it "returns empty array when no provided" do
      expect {
        subject.raw_json["iteminfo"].delete("actress")
      }.to change {
        subject.actresses
      }.to([])
    end
  end

  describe ".as_json" do
    it "filters out affiliate urls" do
      expect(subject.as_json).not_to include("affiliateURL")
      expect(subject.as_json).not_to include("affiliateURLsp")
    end
  end
end
