FactoryBot.define do
  sequence(:id_fanza)

  sequence(:name) do |i|
    "Actress #{i}"
  end

  factory :fanza_actress do
    transient {
      id_fanza
      name
    }

    raw_json {
      {
        id: id_fanza,
        name: name,
        imageURL: {
          large: generate(:url),
          small: generate(:url),
        },
      }
    }
  end
end
