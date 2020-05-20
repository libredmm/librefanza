require "rails_helper"

RSpec.describe FanzaItem, type: :model do
  let(:item) { create :fanza_item }

  it "must have content id" do
    expect {
      create(:fanza_item, content_id: "")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "has unique content id" do
    expect {
      create(:fanza_item, content_id: item.content_id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  %i[title subtitle cover_image_url thumbnail_image_url url].each do |key|
    it "has #{key}" do
      expect(item.send(key)).to be_present
    end
  end

  describe ".as_json" do
    it "filters out affiliate urls" do
      expect(item.as_json).not_to include("affiliateURL")
      expect(item.as_json).not_to include("affiliateURLsp")
    end
  end
end
