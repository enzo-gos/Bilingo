module Noticed::NotificationExtensions
  extend ActiveSupport::Concern

  def broadcast_update_to_index_count(stream_id)
    broadcast_update_to(stream_id, partial: 'shared/notifications/bell', locals: { notification_count: recipient.reload.unread_notifications_count }, target: 'notification_index_count')
  end

  def broadcast_prepend_to_index_list(stream_id)
    broadcast_prepend_to(
      stream_id,
      target: 'notifications',
      partial: 'shared/notifications/notification',
      locals: { notification: self }
    )
  end

  def broadcast_update_to_popup(stream_id)
    broadcast_update_to(
      stream_id,
      target: 'notification-popup',
      partial: 'shared/notifications/pop_up',
      locals: { notification: self }
    )
  end
end
