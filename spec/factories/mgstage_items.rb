FactoryBot.define do
  factory :mgstage_item do
    initialize_with {
      create(:mgstage_product_page).mgstage_item
    }
  end
end
