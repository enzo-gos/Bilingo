module Noticed::NotificationExtensions
  extend ActiveSupport::Concern

  def broadcast_update_to_index_count
    broadcast_update_to("notifications_#{recipient.id}", partial: 'shared/notifications/bell', locals: { notification_count: recipient.reload.unread_notifications_count }, target: 'notification_index_count')
  end

  def broadcast_prepend_to_index_list
    broadcast_prepend_to(
      "notifications_#{recipient.id}",
      target: 'notifications',
      partial: 'shared/notifications/notification',
      locals: { notification: self }
    )
  end

  def broadcast_update_to_popup
    broadcast_update_to(
      "notifications_#{recipient.id}",
      target: 'notification-popup',
      partial: 'shared/notifications/pop_up',
      locals: { notification: self }
    )
  end
end
