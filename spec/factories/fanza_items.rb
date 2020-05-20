FactoryBot.define do
  sequence :content_id do |n|
    "content#{format("%05d", n)}"
  end

  factory :fanza_item do
    raw_json {
      {
        content_id: generate(:content_id),
        date: DateTime.now.to_s,
      }
    }
  end
end
