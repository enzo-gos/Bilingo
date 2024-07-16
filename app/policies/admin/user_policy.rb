# frozen_string_literal: true

class Admin::UserPolicy < ApplicationPolicy
  def create?
    by_admin?
  end

  def update?
    by_admin?
  end

  def destroy?
    by_admin?
  end

  def ban?
    by_admin?
  end

  def unban?
    by_admin?
  end

  private

  def by_admin?
    user.present? && user.has_role?(:admin)
  end
end
