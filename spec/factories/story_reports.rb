# spec/factories/story_reports.rb
FactoryBot.define do
  factory :story_report do
    title { Faker::Lorem.sentence }
    reason { Faker::Lorem.paragraph }
    status { :open }
    association :story
    association :reporter, factory: :user
  end
end
