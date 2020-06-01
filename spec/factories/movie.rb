FactoryBot.define do
  factory :movie do
    initialize_with {
      create(:fanza_item).movie
    }
  end
end
