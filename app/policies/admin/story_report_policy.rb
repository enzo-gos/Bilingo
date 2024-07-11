# frozen_string_literal: true

class Admin::StoryReportPolicy < ApplicationPolicy
  def show?
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
