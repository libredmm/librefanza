require "rails_helper"

RSpec.describe "generic_pages/index" do
  it "works with javlibrary pages" do
    product_page = create :javlibrary_product_page
    search_page = create :javlibrary_search_page
    @pages = JavlibraryPage.all.page(1)

    render
    expect(rendered).to have_text(product_page.url)
    expect(rendered).to have_text(search_page.url)
  end

  it "works with mgstage pages" do
    product_page = create :mgstage_product_page
    search_page = create :mgstage_search_page
    @pages = MgstagePage.all.page(1)

    render
    expect(rendered).to have_text(product_page.url)
    expect(rendered).to have_text(search_page.url)
  end

  it "works with sod pages" do
    page = create :sod_page
    @pages = SodPage.all.page(1)

    render
    expect(rendered).to have_text(page.url)
  end
end
