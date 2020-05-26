require "rails_helper"

RSpec.describe MgstagePage, type: :model do
  describe "search page" do
    let(:page) { create :mgstage_search_page }

    it "does not have item" do
      expect(page.mgstage_item).not_to be_present
    end

    it "recreates items on save" do
      product_page = build :mgstage_product_page

      expect {
        page.raw_html = product_page.raw_html
        page.save
      }.to change {
        page.mgstage_item
      }.from(nil)
    end
  end

  describe "product page" do
    let(:page) { create :mgstage_product_page }

    it "has item" do
      expect(page.mgstage_item).to be_present
    end

    it "rebuilds items on save" do
      id = page.mgstage_item.normalized_id
      new_id = generate(:normalized_id)
      expect {
        page.raw_html.gsub!(id, new_id)
        page.save
      }.to change {
        page.mgstage_item.normalized_id
      }.from(id).to(new_id)
    end
  end
end
