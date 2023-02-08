require "rails_helper"

RSpec.describe FanzaActress, type: :model do
  let(:actress) { create :fanza_actress }

  describe ".image_url" do
    it "prefers large image" do
      expect(actress.image_url).to eq(actress.as_struct.imageURL.large)
    end

    it "falls back to small image" do
      actress.raw_json["imageURL"].delete("large")
      expect(actress.image_url).to eq(actress.as_struct.imageURL.small)
    end
  end

  describe ".as_json" do
    it "contains image url" do
      expect(actress.as_json).to include("image_url")
    end
  end
end
