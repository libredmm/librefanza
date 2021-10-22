require "rails_helper"

RSpec.describe SodPage, type: :model do
  let(:page) { create :sod_page }

  describe "product page" do
    it "has item" do
      expect(page.sod_item).to be_present
    end

    it "rebuilds items on save" do
      id = page.sod_item.normalized_id
      new_id = generate(:normalized_id)
      expect {
        page.raw_html.gsub!(id, new_id)
        page.save
      }.to change {
        page.sod_item.normalized_id
      }.from(id).to(new_id)
    end
  end

  describe "home page" do
    it "gets rejected" do
      url = generate :url
      html = "<html></html>"
      expect {
        SodPage.create!(url: url, raw_html: html)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "invalid page" do
    it "does not have item" do
      url = generate :url
      html = "middle_videos"
      page = SodPage.create!(url: url, raw_html: html)
      expect(page.sod_item).not_to be_present
    end
  end
end
