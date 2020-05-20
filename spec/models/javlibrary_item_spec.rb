require "rails_helper"
require "models/generic_item_spec"

RSpec.describe FanzaItem, type: :model do
  it_behaves_like "generic item" do
    let(:item) { create(:javlibrary_product_page).javlibrary_item }
  end
end
