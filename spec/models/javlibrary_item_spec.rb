require "rails_helper"

RSpec.describe JavlibraryItem, type: :model do
  it_behaves_like "generic item" do
    let(:item) { create(:javlibrary_item) }
  end
end
