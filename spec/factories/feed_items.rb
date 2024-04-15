FactoryBot.define do
  sequence(:guid)

  factory :feed_item do
    guid
    content { "<item></item>" }
  end
end
