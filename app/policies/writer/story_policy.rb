class Writer::StoryPolicy < ApplicationPolicy
  def order?
    record.author == user
  end

  def update?
    record.author == user
  end

  def destroy?
    record.author == user
  end
end
