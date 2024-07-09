FactoryBot.define do
  factory :banned_request do
    title { 'MyString' }
    story { nil }
    requester { nil }
    status { 1 }
  end
end
