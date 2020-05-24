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
        "118docvr00001re01" => "DOCVR-001",
        "1mist00219re01" => "MIST-219",
        "h_1116avopvr00110re01" => "AVOPVR-110",
        "h_1337wvr6d00004" => "WVR6D-004",
        "h_1337wvr9c00009" => "WVR9C-009",
        "wvr9c00009" => "WVR9C-009",
        "149rd00481re01" => "RD-481",
        "abc" => "abc",
        "123" => "123",
        "123abc" => "123abc",
        "abc123def" => "ABC-123",
        "123abc456" => "ABC-456",
        "n_1443omama040" => "OMAMA-040",
      }.each do |original, normalized|
        expect(Fanza::Helper.normalize_id(original)).to eq(normalized)
      end
    end
  end
end
