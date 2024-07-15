class DeliveryMethods::AdminTurboStream < ApplicationDeliveryMethod
  def deliver
    return unless recipient.is_a?(User)

    stream_id = 'notifications_admin'

    notification.broadcast_update_to_index_count(stream_id)
    notification.broadcast_prepend_to_index_list(stream_id)
    notification.broadcast_update_to_popup(stream_id)
  end
end
