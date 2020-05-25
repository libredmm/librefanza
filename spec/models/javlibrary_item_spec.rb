require "rails_helper"

RSpec.describe JavlibraryItem, type: :model do
  subject { create(:javlibrary_item) }

  it_behaves_like "generic item"
end
