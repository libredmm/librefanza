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

  %w[anime pcgame].each do |floor_code|
    it "rejects #{floor_code}" do
      expect {
        create :fanza_item, floor_code: floor_code
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  it "prefer maker product as normalized id" do
    expect {
      item.raw_json["maker_product"] = "MAKER-123"
      item.derive_fields
      item.save
    }.to change {
      item.normalized_id
    }.to("MAKER-123")
  end

  describe ".as_json" do
    it "filters out affiliate urls" do
      expect(item.as_json).not_to include("affiliateURL")
      expect(item.as_json).not_to include("affiliateURLsp")
    end
  end
end
