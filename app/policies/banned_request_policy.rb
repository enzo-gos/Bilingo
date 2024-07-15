class BannedRequestPolicy < ApplicationPolicy
  def show?
    by_author?
  end

  def solved?
    by_author?
  end

  private

  def by_author?
    record.story.author == user
  end
end
