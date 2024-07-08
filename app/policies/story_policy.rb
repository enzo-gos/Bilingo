class StoryPolicy < ApplicationPolicy
  def show?
    record.banned == false
  end
end
