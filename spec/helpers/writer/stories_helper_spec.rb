# spec/helpers/writer/stories_helper_spec.rb
require 'rails_helper'

RSpec.describe Writer::StoriesHelper, type: :helper do
  let(:user) { create(:user) }
  let(:story) { create(:story, author: user.author) }
  let(:chapter) { create(:chapter, story: story) }

  describe '#fake_languages_with_codes' do
    it 'returns an array of languages with codes' do
      expect(helper.fake_languages_with_codes).to be_an(Array)
      expect(helper.fake_languages_with_codes.first).to have_key(:code)
      expect(helper.fake_languages_with_codes.first).to have_key(:language)
    end
  end

  describe '#fake_languages' do
    it 'returns an array of language name/code pairs' do
      languages = helper.fake_languages
      expect(languages).to be_an(Array)
      expect(languages.first).to be_an(Array)
      expect(languages.first.length).to eq(2)
    end
  end

  describe '#format_my_stories' do
    it 'formats the stories correctly' do
      formatted_stories = helper.format_my_stories([story])
      expect(formatted_stories.first).to include(
        id: story.id,
        title: story.name,
        language: story.language_code,
        description: story.description.body.to_s,
        cover: story.cover_image,
        updated: story.updated_at.strftime('%b %d, %Y'),
        is_published: story.number_of_published.positive?,
        published: story.number_of_published,
        draft: story.number_of_draft,
        views: number_to_human(story.views, units: { thousand: 'K', million: 'M' }),
        comments: number_to_human(story.comments, units: { thousand: 'K', million: 'M' })
      )
    end
  end

  describe '#format_chapters' do
    it 'formats the chapters correctly' do
      story = create(:story)
      chapter = create(:chapter, story: story)
      formatted_chapters = helper.format_chapters(story)
      expect(formatted_chapters.first).to include(
        id: chapter.id,
        title: chapter.title,
        updated: chapter.updated_at.strftime('%b %d, %Y'),
        published: chapter.published,
        views: number_to_human(chapter.story_views.size, units: { thousand: 'K', million: 'M' }),
        comments: number_to_human(chapter.comments.size, units: { thousand: 'K', million: 'M' })
      )
    end
  end

  describe '#updatable_content' do
    it 'returns "content hidden" if updatable is true' do
      expect(helper.updatable_content(true)).to eq('content hidden')
    end

    it 'returns "content" if updatable is false' do
      expect(helper.updatable_content(false)).to eq('content')
    end
  end

  describe '#optional_story_title' do
    it 'returns a default message if the story title is nil or empty' do
      expect(helper.optional_story_title({ name: nil })).to eq(t('writer_toolbar.untitled_story'))
      expect(helper.optional_story_title({ name: '' })).to eq(t('writer_toolbar.untitled_story'))
    end

    it 'returns the story title if it is present' do
      expect(helper.optional_story_title({ name: 'My Awesome Story' })).to eq('My Awesome Story')
    end
  end

  describe '#optional_chapter_title' do
    it 'returns a default message if the chapter title is nil or empty' do
      expect(helper.optional_chapter_title({ title: nil })).to eq(t('writer_toolbar.untitled_chapter'))
      expect(helper.optional_chapter_title({ title: '' })).to eq(t('writer_toolbar.untitled_chapter'))
    end

    it 'returns the chapter title if it is present' do
      expect(helper.optional_chapter_title({ title: 'Chapter 1' })).to eq('Chapter 1')
    end
  end
end
