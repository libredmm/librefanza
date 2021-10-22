require 'rails_helper'

RSpec.describe SodItem, type: :model do
  subject { create(:sod_item) }

  it_behaves_like "generic item"
end
