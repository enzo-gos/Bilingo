module CommentsHelper
  def format_comments(all_commments)
    all_commments.map do |comment|
      comment_object(comment)
    end
  end

  def comment_object(comment)
    {
      id: comment.id,
      story_id: comment.chapter.story_id,
      chapter_id: comment.chapter.id,
      avatar: comment.commenter.last_name.first,
      commenter: comment.commenter,
      p_id: comment.paragraph_id,
      comment: comment.comment,
      created_at: comment.created_at
    }
  end
end
