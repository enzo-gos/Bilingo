# To deliver this notification:
#
# SolvedRequestNotifier.with(record: @post, message: "New post").deliver(User.all)

class SolvedRequestNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end

  deliver_by :turbo_stream, class: 'DeliveryMethods::AdminTurboStream'

  def message
    "Report: #{record.reason}".html_safe
  end

  def title
    "<b>#{record.story.author.fullname}</b> has solved report on <b>#{record.story.name}</b>".html_safe
  end

  def icon
    params[:icon]
  end

  def destination_path
    admin_report_path(id: record.story_report.id)
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
