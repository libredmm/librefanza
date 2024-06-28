require "rails_helper"

RSpec.describe Fc2Page, type: :model do
  let(:page) { create :fc2_page }

  describe "product page" do
    it "has item" do
      expect(page.fc2_item).to be_present
    end
  end

  describe "home page" do
    it "gets rejected" do
      url = generate :url
      html = "<html></html>"
      expect {
        Fc2Page.create!(url: url, raw_html: html)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "invalid page" do
    it "does not have item" do
      url = generate :url
      html = "items_article_header"
      page = Fc2Page.create!(url: url, raw_html: html)
      expect(page.fc2_item).not_to be_present
    end
  end
end
