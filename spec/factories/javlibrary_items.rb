FactoryBot.define do
  factory :javlibrary_item do
    javlibrary_page { build :javlibrary_product_page }
  end
end
