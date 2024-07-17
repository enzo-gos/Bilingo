FactoryBot.define do
  factory :comment do
    comment { Faker::Lorem.sentence }
    paragraph_id { 1 }
    association :chapter
    association :commenter, factory: :user
  end
end
