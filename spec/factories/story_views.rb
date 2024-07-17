FactoryBot.define do
  factory :story_view do
    viewed_on { Date.current }
    ip_address { Faker::Internet.ip_v4_address }
    association :story
    association :chapter
  end
end
