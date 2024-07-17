FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'password' }
    active { true }

    trait :admin do
      after(:create) do |user|
        user.add_role(:admin)
      end
    end
  end
end
