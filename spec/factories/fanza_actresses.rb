FactoryBot.define do
  sequence(:id_fanza)

  sequence(:name) do |i|
    "Actress #{i}"
  end

  factory :fanza_actress do
    raw_json {
      {
        id: generate(:id_fanza),
        name: generate(:name),
        imageURL: {
          large: generate(:url),
          small: generate(:url),
        },
      }
    }
  end
end
