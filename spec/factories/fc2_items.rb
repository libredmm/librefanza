FactoryBot.define do
  sequence :fc2_id do |i|
    "FC2-#{format("%06d", i)}"
  end

  factory :fc2_item do
    initialize_with {
      create(:fc2_page).fc2_item
    }
  end
end
