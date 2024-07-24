# spec/helpers/comments_helper_spec.rb
require 'rails_helper'

RSpec.describe CommentsHelper, type: :helper do
  describe '#format_comments' do
    let!(:user) { create(:user) }
    let!(:story) { create(:story) }
    let!(:chapter) { create(:chapter, story: story) }
    let!(:comments) do
      create_list(:comment, 3, chapter: chapter, commenter: user, paragraph_id: Faker::Number.number(digits: 2))
    end

    it 'formats comments correctly' do
      formatted_comments = helper.format_comments(comments)
      expect(formatted_comments.size).to eq(comments.size)

      comments.each do |comment|
        formatted_comment = formatted_comments.find { |c| c[:id] == comment.id }
        expect(formatted_comment).to include(
          id: comment.id,
          story_id: comment.chapter.story_id,
          chapter_id: comment.chapter.id,
          avatar: comment.commenter.last_name.first,
          commenter: comment.commenter,
          p_id: comment.paragraph_id,
          comment: comment.comment,
          created_at: comment.created_at
        )
      end
    end
  end

  describe '#comment_object' do
    let!(:user) { create(:user) }
    let!(:story) { create(:story) }
    let!(:chapter) { create(:chapter, story: story) }
    let!(:comment) { create(:comment, chapter: chapter, commenter: user, paragraph_id: Faker::Number.number(digits: 2)) }

    it 'returns a formatted hash for a comment' do
      formatted_comment = helper.comment_object(comment)
      expect(formatted_comment).to include(
        id: comment.id,
        story_id: comment.chapter.story_id,
        chapter_id: comment.chapter.id,
        avatar: comment.commenter.last_name.first,
        commenter: comment.commenter,
        p_id: comment.paragraph_id,
        comment: comment.comment,
        created_at: comment.created_at
      )
    end
  end
end
