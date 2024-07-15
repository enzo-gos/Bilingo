class DeliveryMethods::TurboStream < ApplicationDeliveryMethod
  def deliver
    return unless recipient.is_a?(User)

    notification.broadcast_update_to_index_count
    notification.broadcast_prepend_to_index_list
    notification.broadcast_update_to_popup
  end
end
