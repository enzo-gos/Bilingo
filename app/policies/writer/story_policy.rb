class Writer::StoryPolicy < ApplicationPolicy
  def order?
    by_author?
  end

  def create?
    by_author?
  end

  def update?
    by_author?
  end

  def destroy?
    by_author?
  end

  private

  def by_author?
    record.author == user
  end
end
