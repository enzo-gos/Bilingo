class StoryPolicy < ApplicationPolicy
  def show?
    user.has_role?(:admin) || record.banned == false
  end
end
