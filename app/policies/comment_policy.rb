class CommentPolicy < ApplicationPolicy
  def create?
    commenter?
  end

  def reply?
    user.present? && record.commenter != user
  end

  def destroy?
    commenter? || user.has_role?(:admin) || user.author == record.chapter.story.author
  end

  private

  def commenter?
    user.present? && record.commenter == user
  end
end
