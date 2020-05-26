require "rails_helper"

RSpec.describe MgstageItem, type: :model do
  subject { create(:mgstage_item) }

  it_behaves_like "generic item"
end
