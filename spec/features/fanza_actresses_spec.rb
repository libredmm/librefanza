require "rails_helper"

RSpec.feature "FanzaActresses", type: :feature do
  scenario "actress has movies" do
    item = create :fanza_item
    actress = item.actresses.first
    visit fanza_actress_path(actress)
    expect(page).to have_text(item.normalized_id)
  end
end
