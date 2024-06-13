class Writer::StoryPolicy < ApplicationPolicy
  def update?
    record.author == user
  end

  def destroy?
    record.author == user
  end
end
