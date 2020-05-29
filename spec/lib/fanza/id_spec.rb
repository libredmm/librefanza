require "rails_helper"

RSpec.describe Fanza::Id do
  describe "#normalize" do
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
        "h_006ghta" => "h_006ghta",
        "GHT-000A" => "GHT-000",
        "BIC-MAN" => "BIC-MAN",
        "180_1507" => "180_1507",
        "t28526" => "T28-526",
        "55t2800147" => "T28-147",
        "13dsvr00003" => "3DSVR-003",
        "3dsvr00003" => "3DSVR-003",
        "3DSVR-003" => "3DSVR-003",
        "dsvr00005" => "DSVR-005",
        "1073DSVR-0020" => "3DSVR-020",
      }.each do |original, normalized|
        expect(Fanza::Id.normalize(original)).to eq(normalized)
      end
    end

    it "handles invalid inputs" do
      {
        nil => nil,
        "" => "",
      }.each do |original, normalized|
        expect(Fanza::Id.normalize(original)).to eq(normalized)
      end
    end
  end

  describe "#normalized?" do
    it "tells if an id is normalized" do
      [
        "ABC",
        "123",
      ].each do |id|
        expect(Fanza::Id.normalized?(id)).to be_falsy
      end

      [
        "ABC-123",
        "edf-456",
        "T28-526",
        "3DSVR-003",
        "WVR9C-009",
      ].each do |id|
        expect(Fanza::Id.normalized?(id)).to be_truthy
      end
    end
  end

  describe "#variations" do
    context "of unnormalized id" do
      it "returns itself" do
        [
          "ABP",
          "3DSVR",
        ].each do |original|
          expect(Fanza::Id.variations(original)).to eq(Set[original])
        end
      end
    end

    context "of normalzied id" do
      it "works" do
        {
          "ABP-123" => Set["ABP-123", "abp123", "abp00123"],
          "ABP-001" => Set["ABP-001", "abp001", "abp00001"],
          "XV-1001" => Set["XV-1001", "xv1001", "xv01001"],
          "HODV-60069" => Set["HODV-60069", "hodv60069"],
          "T28-526" => Set["T28-526", "t28526", "t2800526"],
          "3DSVR-003" => Set["3DSVR-003", "3dsvr003", "3dsvr00003"],
          "DSVR-005" => Set["DSVR-005", "dsvr005", "dsvr00005"],
          "EXVR-092" => Set["EXVR-092", "exvr092", "exvr00092"],
        }.each do |original, variations|
          expect(Fanza::Id.variations(original)).to eq(variations)
        end
      end
    end
  end
end
