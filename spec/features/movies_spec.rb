require "rails_helper"

RSpec.feature "Movies", type: :feature do
  let(:admin) { create(:admin) }

  scenario "fuzzy search" do
    abp = create :fanza_item, content_id: "abp123"
    sdde = create :fanza_item, content_id: "sdde234"
    visit movies_path(q: "abp", as: admin)
    expect(page).to have_text(abp.normalized_id)
    expect(page).not_to have_text(sdde.normalized_id)
  end

  scenario "prefix search" do
    bp = create :fanza_item, content_id: "bp456"
    abp = create :fanza_item, content_id: "abp123"
    visit movies_path(q: "bp", style: "prefix", as: admin)
    expect(page).to have_text(bp.normalized_id)
    expect(page).not_to have_text(abp.normalized_id)
  end

  scenario "with hidden movies" do
    movie = create :movie
    hidden = create :movie, is_hidden: true
    visit movies_path(as: admin)
    expect(page).to have_text(movie.normalized_id)
    expect(page).not_to have_text(hidden.normalized_id)
  end

  context "sorting" do
    before(:each) do
      create :fanza_item, content_id: "AA", date: 3.day.ago
      create :fanza_item, content_id: "BB", date: 1.day.ago
      create :fanza_item, content_id: "CC", date: 2.day.ago
    end

    scenario "by title" do
      visit movies_path(order: "title", as: admin)
      expect(page).to have_text(/AA.+BB.+CC/m)
    end

    scenario "by release date" do
      visit movies_path(order: "release_date", as: admin)
      expect(page).to have_text(/BB.+CC.+AA/m)
    end

    scenario "by date added" do
      visit movies_path(order: "date_added", as: admin)
      expect(page).to have_text(/CC.+BB.+AA/m)
    end
  end
end
