class CommentPolicy < ApplicationPolicy
  def destroy?
    record.commenter == user
  end
end
