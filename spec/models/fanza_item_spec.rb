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

  it "formats to raw json" do
    expect(item.as_json).to equal(item.raw_json)
  end
end
