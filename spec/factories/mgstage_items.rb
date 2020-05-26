FactoryBot.define do
  factory :mgstage_item do
    mgstage_page { build :mgstage_product_page }
  end
end
