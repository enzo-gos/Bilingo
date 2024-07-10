FactoryBot.define do
  factory :story_report do
    title { "MyString" }
    story { nil }
    reporter { nil }
    status { 1 }
  end
end
