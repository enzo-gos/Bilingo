class Comment < ApplicationRecord
  include CommentsHelper

  has_rich_text :comment

  belongs_to :commenter, class_name: :User
  belongs_to :chapter

  validates :comment,
            :commenter,
            :chapter,
            :paragraph_id,
            presence: true

  after_create_commit :broadcast_create_comment
  after_destroy_commit :broadcast_destroy_comment

  private

  def broadcast_create_comment
    broadcast_append_to "chapter_#{chapter_id}", partial: 'chapters/comment/comment', locals: { comment: comment_object(self) }, target: "comments_#{chapter_id}_#{paragraph_id}"
    broadcast_update_to "chapter_#{chapter_id}", partial: 'chapters/comment_count', locals: { chapter: chapter, index: paragraph_id }, target: "comment_count_#{chapter_id}_#{paragraph_id}"
  end

  def broadcast_destroy_comment
    broadcast_remove_to "chapter_#{chapter_id}", target: "comment-item#{id}"
    broadcast_update_to "chapter_#{chapter_id}", partial: 'chapters/comment_count', locals: { chapter: chapter, index: paragraph_id }, target: "comment_count_#{chapter_id}_#{paragraph_id}"
  end
end
