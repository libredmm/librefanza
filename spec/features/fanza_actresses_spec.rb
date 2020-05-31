require "rails_helper"

RSpec.feature "FanzaActresses", type: :feature do
  scenario "actress has movies" do
    item = create :fanza_item
    actress = item.actresses.first
    visit fanza_actress_path(actress)
    expect(page).to have_text(item.normalized_id)
  end

  scenario "fuzzy searching" do
    actress = create :fanza_actress, name: "SPECIAL"
    create_list :fanza_actress, 3
    visit fanza_actresses_path(fuzzy: "special")
    expect(page).to have_selector(".card.actress", count: 1)
  end

  context "sorting" do
    before(:each) do
      create :fanza_actress, fanza_id: 1, name: "Actress A"
      create :fanza_actress, fanza_id: 2, name: "Actress B"
      create :fanza_actress, fanza_id: 3, name: "Actress C"
    end

    scenario "by new" do
      visit fanza_actresses_path(order: "new")
      expect(page).to have_text(/Actress C.+Actress B.+Actress A/m)
    end

    scenario "by name" do
      visit fanza_actresses_path(order: "name")
      expect(page).to have_text(/Actress A.+Actress B.+Actress C/m)
    end
  end
end
