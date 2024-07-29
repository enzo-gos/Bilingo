class BannedRequestPolicy < ApplicationPolicy
  def show?
    by_author?
  end

  def solved?
    by_author?
  end

  private

  def by_author?
    user.present? && record.story.author == user.author
  end
end
