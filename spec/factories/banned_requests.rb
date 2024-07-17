FactoryBot.define do
  factory :banned_request do
    association :story
    association :requester, factory: :user
    association :story_report, factory: :story_report, strategy: :build
    title { Faker::Lorem.sentence }
    reason { Faker::Lorem.paragraph }
    status { BannedRequest.statuses.keys.sample }

    trait :open do
      status { :open }
    end

    trait :handled do
      status { :handled }
    end

    trait :accepted do
      status { :accepted }
    end

    trait :closed do
      status { :closed }
    end
  end
end
