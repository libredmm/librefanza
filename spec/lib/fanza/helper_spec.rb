require "rails_helper"

RSpec.describe "Fanza::Helper" do
  describe "#normalize_id" do
    it "works" do
      {
        "abp123" => "ABP-123",
        "abp00123" => "ABP-123",
        "abp00123dod" => "ABP-123",
        "abp00001" => "ABP-001",
        "104bshd16" => "BSHD-16",
        "h_244sama083dod" => "SAMA-083",
        "118ezd300_ar" => "EZD-300",
        "1230crs010a_t" => "CRS-010",
        "55csct005tk2" => "CSCT-005",
        "ABP-123" => "ABP-123",
        "2APAA-101" => "APAA-101",
        "td008dv1569d" => "DV-1569",
        "DV1-662" => "DV-1662",
        "7DV1-667" => "DV-1667",
        "7ADVO-9" => "ADVO-009",
        "8ADV-F126" => "ADVF-126",
        "d2cesd901" => "CESD-901",
        "ut3fzr025" => "FZR-025",
        "k9cawd085" => "CAWD-085",
        "118tdt004dod" => "TDT-004",
        "140c2344" => "C-2344",
      }.each do |original, normalized|
        expect(Fanza::Helper.normalize_id(original)).to eq(normalized)
      end
    end
  end
end
