class AdminPolicy < ApplicationPolicy
  def admin_access?
    user.present? && user.has_role?(:admin)
  end
end
