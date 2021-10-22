FactoryBot.define do
  factory :sod_item do
    initialize_with {
      create(:sod_page).sod_item
    }
  end
end
