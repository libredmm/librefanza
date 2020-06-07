require "rails_helper"

RSpec.describe HouseKeeper, type: :worker do
  it "can re-derive fields" do
    create(:fanza_item)
    expect_any_instance_of(FanzaItem).to receive(:derive_fields!)
    create(:mgstage_item)
    expect_any_instance_of(MgstageItem).to receive(:derive_fields!)
    create(:javlibrary_item)
    expect_any_instance_of(JavlibraryItem).to receive(:derive_fields!)
    subject.perform :derive_fields
  end

  it "ignores invalid task" do
    subject.perform :invalid_task
  end
end
