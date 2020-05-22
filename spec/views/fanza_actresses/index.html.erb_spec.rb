require "rails_helper"

RSpec.describe "fanza_actresses/index" do
  before :each do
    5.times do
      create :fanza_actress
    end
    @actresses = FanzaActress.all.page(1)
  end

  it "renders actress image" do
    render
    expect(rendered).to have_selector("img[src='#{@actresses.first.image_url}']")
  end

  it "uses dummy image as place holder" do
    @actresses.first.raw_json["imageURL"].delete("large")
    @actresses.first.raw_json["imageURL"].delete("small")
    @actresses.first.save
    render
    expect(rendered).to have_selector("img[src*='dummyimage.com']")
  end
end
