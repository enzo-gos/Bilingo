FactoryBot.define do
  factory :comment do
    commenter { nil }
    chapter { nil }
    comment { 'MyString' }
  end
end
