class Comment < ApplicationRecord
  include CommentsHelper
  include ProfanityFilter

  has_rich_text :comment

  belongs_to :commenter, class_name: :User, counter_cache: true
  belongs_to :chapter, counter_cache: true

  validates :comment,
            :commenter,
            :chapter,
            :paragraph_id,
            presence: true

  after_create_commit :broadcast_create_comment
  before_create :validate_is_author
  after_destroy_commit :broadcast_destroy_comment

  validate :content_should_be_clean

  private

  def content_should_be_clean
    if ProfanityFilter::Base.profane?(comment.body.to_s)
      errors.add(:profanity_word, 'Your comment violates our community standards')
    end
  end

  def broadcast_create_comment
    broadcast_append_to "chapter_#{chapter_id}", partial: 'chapters/comment/comment', locals: { comment: comment_object(self), show_only: false }, target: "comments_#{chapter_id}_#{paragraph_id}"
    broadcast_update_to "chapter_#{chapter_id}", partial: 'chapters/comment_count', locals: { chapter: chapter, index: paragraph_id }, target: "comment_count_#{chapter_id}_#{paragraph_id}"

    broadcast_append_to "chapter_#{chapter_id}", partial: 'chapters/comment/comment_item', locals: { key: paragraph_id, comment: comment_object(self) }, target: "comment_list_#{chapter_id}" if chapter.count_comments(paragraph_id) == 1
  end

  def broadcast_destroy_comment
    broadcast_remove_to "chapter_#{chapter_id}", target: "comment-item#{id}"
    broadcast_update_to "chapter_#{chapter_id}", partial: 'chapters/comment_count', locals: { chapter: chapter, index: paragraph_id }, target: "comment_count_#{chapter_id}_#{paragraph_id}"

    broadcast_remove_to "chapter_#{chapter_id}", target: "comment_list_#{chapter_id}_item_#{paragraph_id}" if chapter.count_comments(paragraph_id).zero?
  end

  def validate_is_author
    self.is_author = commenter.author == chapter.story.author
  end
end
