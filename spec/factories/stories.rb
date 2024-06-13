FactoryBot.define do
  factory :story do
    name { "MyString" }
    description { "MyText" }
    language_code { "MyString" }
    primary_genre { nil }
    secondary_genre { nil }
    author { nil }
  end
end
