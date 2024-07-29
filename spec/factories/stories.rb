FactoryBot.define do
  factory :story do
    name { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    language_code { 'en' }
    cover_image { Rack::Test::UploadedFile.new('spec/fixtures/files/cover_image.jpg', 'image/jpeg') }
    tag_list { '[{"value":"tag1"}, {"value":"tag2"}]' }
    association :author, factory: :author_infor
    association :primary_genre, factory: :genre
  end
end
