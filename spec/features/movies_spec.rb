require "rails_helper"

RSpec.feature "Movies", type: :feature do
  scenario "fuzzy search" do
    abp = create :fanza_item, content_id: "abp123"
    sdde = create :fanza_item, content_id: "sdde234"
    visit movies_path(fuzzy: "abp")
    expect(page).to have_text(abp.normalized_id)
    expect(page).not_to have_text(sdde.normalized_id)
  end

  context "sorting" do
    before(:each) do
      create :fanza_item, content_id: "AA"
      create :fanza_item, content_id: "BB"
      create :fanza_item, content_id: "CC"
    end

    scenario "by new" do
      visit movies_path(order: "new")
      expect(page).to have_text(/CC.+BB.+AA/m)
    end

    scenario "by id" do
      visit movies_path(order: "id")
      expect(page).to have_text(/AA.+BB.+CC/m)
    end
  end
end
