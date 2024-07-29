# spec/factories/author_infos.rb
FactoryBot.define do
  factory :author_infor do
    association :user
    nickname { Faker::Internet.username }

    # If you need to attach an avatar
    # after(:build) do |author_infor|
    #   author_infor.avatar.attach(
    #     io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.png')),
    #     filename: 'avatar.png',
    #     content_type: 'image/png'
    #   )
    # end

    # Optional: Create stories and votes if needed for testing `total_followers`
    after(:create) do |author_infor|
      create_list(:story, 3, author: author_infor)
    end
  end
end
