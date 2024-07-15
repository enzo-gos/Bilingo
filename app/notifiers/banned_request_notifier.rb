# To deliver this notification:
#
# BannedRequestNotifier.with(record: @post, message: "New post").deliver(User.all)

class BannedRequestNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = 'AdminMailer'
  #   config.method = 'new_report'
  # end

  deliver_by :turbo_stream, class: 'DeliveryMethods::UserTurboStream'

  def message
    t('notifications.banned_request.reason', title: record.title, reason: record.reason.body.to_plain_text.truncate_words(20)).html_safe
  end

  def title
    t('notifications.banned_request.title', story: record.story.name, status: t("notifications.banned_request.status.#{record.status}")).html_safe
  end

  def icon
    params[:icon]
  end

  def destination_path
    story_report_path(story_id: record.story.id, id: record.id)
  end

  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  # required_param :message
end
