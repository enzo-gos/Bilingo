# frozen_string_literal: true

class Admin::BannedRequestPolicy < ApplicationPolicy
  def new?
    by_admin?
  end

  def create?
    by_admin?
  end

  def close?
    by_admin?
  end

  def accept?
    by_admin?
  end

  private

  def by_admin?
    user.has_role? :admin
  end
end
