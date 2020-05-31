FactoryBot.define do
  sequence(:fanza_id)

  sequence(:name) do |i|
    "Actress #{i}"
  end

  factory :fanza_actress do
    transient {
      fanza_id
      name
    }

    raw_json {
      {
        id: fanza_id,
        name: name,
        imageURL: {
          large: generate(:url),
          small: generate(:url),
        },
      }
    }
  end
end
