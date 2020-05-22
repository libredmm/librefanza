require "rails_helper"

RSpec.describe FanzaActress, type: :model do
  let(:actress) { create :fanza_actress }

  describe ".imageUrl" do
    it "prefer large image" do
      expect(actress.imageUrl).to eq(actress.as_struct.imageURL.large)
    end

    it "falls back to small image" do
      actress.raw_json["imageURL"].delete("large")
      expect(actress.imageUrl).to eq(actress.as_struct.imageURL.small)
    end

    it "falls back to place holder image" do
      actress.raw_json["imageURL"].delete("large")
      actress.raw_json["imageURL"].delete("small")
      expect(actress.imageUrl).to start_with("https://dummyimage.com/")
    end
  end
end
