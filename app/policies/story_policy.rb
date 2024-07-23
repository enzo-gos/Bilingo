class StoryPolicy < ApplicationPolicy
  def show?
    by_admin? || active?
  end

  def translate?
    by_admin? || active?
  end

  def rephrase?
    by_admin? || active?
  end

  def rephrase_alt?
    by_admin? || active?
  end

  def summarize?
    by_admin? || active?
  end

  def summarize_alt?
    by_admin? || active?
  end

  def follow
    user.present? && active?
  end

  private

  def by_admin?
    user.present? && user.has_role?(:admin)
  end

  def active?
    !record.banned
  end
end
