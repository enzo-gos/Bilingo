class ChapterPolicy < ApplicationPolicy
  def show?
    published? || by_admin? || by_author?
  end

  def translate?
    published? || by_admin? || by_author?
  end

  def rephrase?
    published? || by_admin? || by_author?
  end

  def rephrase_alt?
    published? || by_admin? || by_author?
  end

  def summarize?
    published? || by_admin? || by_author?
  end

  def summarize_alt?
    published? || by_admin? || by_author?
  end

  private

  def by_admin?
    user.present? && user.has_role?(:admin)
  end

  def published?
    record.published
  end

  def by_author?
    user.present? && record.story.author == user.author
  end
end
