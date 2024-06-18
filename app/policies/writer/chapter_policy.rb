class Writer::ChapterPolicy < ApplicationPolicy
  def index?
    by_author?
  end

  def order?
    by_author?
  end

  def create?
    by_author?
  end

  def update?
    by_author?
  end

  def republish?
    by_author?
  end

  def publish?
    by_author?
  end

  def unpublish?
    by_author?
  end

  def destroy?
    by_author?
  end

  private

  def by_author?
    record.story.author == user
  end
end
