# To deliver this notification:
#
# Writer::PublishChapterNotifier.with(record: @post, message: "New post").deliver(User.all)

class Writer::PublishChapterNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end

  deliver_by :turbo_stream, class: 'DeliveryMethods::UserTurboStream'

  def message
    t('notifications.publish_chapter.message')
  end

  def title
    t('notifications.publish_chapter.title', story: record.story.name, chapter: record.title).html_safe
  end

  def icon
    params[:icon]
  end

  def destination_path
    story_path(id: record.story.id)
  end

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
