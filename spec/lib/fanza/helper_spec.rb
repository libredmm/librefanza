require "rails_helper"

RSpec.describe "Fanza::Helper" do
  describe "#normalize_id" do
    it "works" do
      {
        "abp123" => "ABP-123",
        "abp00123" => "ABP-123",
        "abp00001" => "ABP-001",
      }.each do |original, normalized|
        expect(Fanza::Helper.normalize_id(original)).to eq(normalized)
      end
    end
  end
end
