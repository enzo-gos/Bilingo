require 'rails_helper'
require 'faker'

RSpec.describe Story, type: :model do
  describe 'associations' do
    it { should belong_to(:primary_genre).class_name('Genre') }
    it { should belong_to(:secondary_genre).class_name('Genre').optional }
    it { should belong_to(:author).class_name('User').counter_cache(true) }
    it { should have_many(:chapters).order(position: :asc) }
    it { should have_many(:story_views) }
    it { should have_many(:banned_requests) }
    it { should have_many(:story_reports) }
    it { should have_one_attached(:cover_image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:primary_genre_id) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:cover_image) }
    it { should validate_presence_of(:tag_list) }
    it { should validate_presence_of(:language_code) }
  end

  describe 'scopes' do
    let!(:story) { create(:story) }
    let!(:chapter) { create(:chapter, story: story, published: true) }

    describe '.with_published' do
      it 'includes stories with published chapters' do
        expect(Story.with_published).to include(story)
      end

      it 'excludes stories without published chapters' do
        chapter.update(published: false)
        expect(Story.with_published).not_to include(story)
      end
    end

    describe '.top_viewed' do
      let!(:story_view) { create(:story_view, story: story) }

      it 'returns stories ordered by view count' do
        expect(Story.top_viewed.first).to eq(story)
      end
    end

    describe '.recently_read' do
      let!(:story_view) { create(:story_view, story: story) }

      it 'returns stories ordered by recently viewed' do
        expect(Story.recently_read(story_view.ip_address).first).to eq(story)
      end
    end
  end

  describe 'instance methods' do
    let!(:story) { create(:story) }
    let!(:chapter) { create(:chapter, story: story, published: true) }

    describe '#number_of_published' do
      it 'returns the count of published chapters' do
        expect(story.number_of_published).to eq(1)
      end
    end

    describe '#number_of_draft' do
      before { chapter.update(published: false) }

      it 'returns the count of draft chapters' do
        expect(story.number_of_draft).to eq(1)
      end
    end

    describe '#views' do
      let!(:story_view) { create(:story_view, story: story) }

      it 'returns the total number of views' do
        expect(story.views).to eq(1)
      end
    end

    describe '#comments' do
      let!(:comment) { create(:comment, chapter: chapter, commenter: create(:user), paragraph_id: 1) }

      it 'returns the total number of comments' do
        expect(story.comments).to eq(1)
      end
    end

    describe '#genres' do
      let(:secondary_genre) { create(:genre) }

      it 'returns an array of genre names' do
        story.update(secondary_genre: secondary_genre)

        expect(story.genres).to eq([story.primary_genre.name, secondary_genre.name]) unless story.primary_genre.name == secondary_genre.name
        expect(story.genres).to eq([story.primary_genre.name]) if story.primary_genre.name == secondary_genre.name
      end
    end

    describe '#track_view' do
      it 'creates a new story view' do
        expect { story.track_view('127.0.0.1', chapter.id) }.to change { StoryView.count }.by(1)
      end
    end

    describe '#views_by_day' do
      let!(:story_view) { create(:story_view, story: story, viewed_on: Date.current) }

      it 'returns views grouped by day' do
        expect(story.views_by_day).to eq({ Date.current.day => 1 })
      end
    end
  end
end
