require "rails_helper"

RSpec.feature "Movies", type: :feature do
  scenario "fuzzy search" do
    abp = create :fanza_item, content_id: "abp123"
    sdde = create :fanza_item, content_id: "sdde234"
    visit movies_path(fuzzy: "abp")
    expect(page).to have_text(abp.normalized_id)
    expect(page).not_to have_text(sdde.normalized_id)
  end
end
