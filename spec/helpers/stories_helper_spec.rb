require 'rails_helper'

RSpec.describe StoriesHelper, type: :helper do
  describe '#story_meta' do
    let(:story) do
      create(
        :story,
        description: Faker::Lorem.paragraph,
        tag_list: Faker::Lorem.words(number: 3),
        primary_genre: primary_genre,
        secondary_genre: secondary_genre,
        cover_image: cover_image
      )
    end
    let(:primary_genre) { create(:genre, name: Faker::Book.genre) }
    let(:secondary_genre) { create(:genre, name: Faker::Book.genre) }
    let(:cover_image) { fixture_file_upload('spec/fixtures/files/cover_image.jpg', 'image/jpg') }

    before do
      allow(helper).to receive(:rails_blob_url).and_return('http://example.com/cover_image.jpg')
    end

    it 'sets meta tags for the story' do
      expect(helper).to receive(:set_meta_tags).with(
        title: story.name,
        description: story.description.body.to_s,
        image: 'http://example.com/cover_image.jpg',
        keywords: "#{story.tag_list.join(', ')}, #{story.primary_genre.name}, #{story.secondary_genre&.name}",
        og: {
          title: story.name,
          description: story.description.body.to_s,
          image: 'http://example.com/cover_image.jpg'
        }
      )

      helper.story_meta(story)
    end
  end
end
