class NotificationsController < ApplicationController
  def read
    notification = Noticed::Notification.find(params[:id])
    authorize notification, policy_class: NotificationPolicy
    notification.mark_as_read
    head :ok
  end
end
