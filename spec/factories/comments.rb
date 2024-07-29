FactoryBot.define do
  factory :comment do
    comment { 'Hello World' }
    paragraph_id { 1 }
    is_author { false }
    association :chapter
    association :commenter, factory: :user
  end
end
