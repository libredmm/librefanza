require "rails_helper"

RSpec.describe JavlibraryPage, type: :model do
  describe "search page" do
    let!(:page) { create :javlibrary_search_page }

    it "does not have item" do
      expect(page.javlibrary_item).not_to be_present
    end

    it "recreates items on save" do
      product_page = build :javlibrary_product_page

      expect {
        page.raw_html = product_page.raw_html
        page.save
      }.to change {
        page.javlibrary_item
      }.from(nil)
    end
  end

  describe "product page" do
    let!(:page) { create :javlibrary_product_page }

    it "has item" do
      expect(page.javlibrary_item).to be_present
    end

    it "rebuilds items on save" do
      id = page.javlibrary_item.normalized_id
      new_id = generate(:normalized_id)
      expect {
        page.raw_html.gsub!(id, new_id)
        page.save
      }.to change {
        page.javlibrary_item.normalized_id
      }.from(id).to(new_id)
    end
  end
end
