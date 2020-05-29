FactoryBot.define do
  factory :javlibrary_item do
    initialize_with {
      create(:javlibrary_product_page).javlibrary_item
    }
  end
end
