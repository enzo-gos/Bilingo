class NotificationPolicy < ApplicationPolicy
  def read?
    user.present? && record.recipient == user
  end
end
