class DeliveryMethods::UserTurboStream < ApplicationDeliveryMethod
  def deliver
    return unless recipient.is_a?(User)

    stream_id = "notifications_#{recipient.id}"

    notification.broadcast_update_to_index_count(stream_id)
    notification.broadcast_prepend_to_index_list(stream_id)
    notification.broadcast_update_to_popup(stream_id)
  end
end
