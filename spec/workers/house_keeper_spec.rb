require "rails_helper"

RSpec.describe HouseKeeper, type: :worker do
  it "fetches raw html for fanza items" do
    create(:fanza_item).update_column(:raw_html, "")
    expect_any_instance_of(FanzaItem).to receive(:fetch_html!)
    subject.perform
  end
end
