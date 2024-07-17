FactoryBot.define do
  factory :chapter do
    title { Faker::Book.title }
    content { Faker::Lorem.paragraph }
    published { false }
    association :story
  end
end
