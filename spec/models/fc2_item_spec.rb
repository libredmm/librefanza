require "rails_helper"

RSpec.describe Fc2Item, type: :model do
  subject { create(:fc2_item) }

  it_behaves_like "generic item"
end
