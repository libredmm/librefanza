require "rails_helper"
require "models/generic_item_spec"

RSpec.describe FanzaItem, type: :model do
  it_behaves_like "generic item" do
    let(:item) { create :fanza_item }
  end

  let(:item) { create :fanza_item }

  describe ".as_json" do
    it "filters out affiliate urls" do
      expect(item.as_json).not_to include("affiliateURL")
      expect(item.as_json).not_to include("affiliateURLsp")
    end
  end
end
