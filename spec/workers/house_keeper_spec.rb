require "rails_helper"

RSpec.describe HouseKeeper, type: :worker do
  it "can fetch missing raw html" do
    create(:fanza_item).update_column(:raw_html, "")
    expect_any_instance_of(FanzaItem).to receive(:fetch_html!)
    subject.perform :fetch_html
  end

  it "can re-derive fields" do
    create(:fanza_item)
    create(:mgstage_item)
    create(:javlibrary_item)
    expect_any_instance_of(FanzaItem).to receive(:derive_fields!)
    expect_any_instance_of(MgstageItem).to receive(:derive_fields!)
    expect_any_instance_of(JavlibraryItem).to receive(:derive_fields!)
    subject.perform :derive_fields
  end

  it "ignores invalid task" do
    subject.perform :invalid_task
  end
end
