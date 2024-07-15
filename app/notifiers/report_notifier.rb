# To deliver this notification:
#
# ReportNotifier.with(record: @post, message: "New post").deliver(User.all)

class ReportNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = 'AdminMailer'
  #   config.method = 'new_report'
  # end

  deliver_by :turbo_stream, class: 'DeliveryMethods::AdminTurboStream'

  def message
    "Reason: #{record.reason}".html_safe
  end

  def title
    "<b>#{record.reporter.fullname}</b> has reported <b>#{record.story.name}</b>".html_safe
  end

  def icon
    params[:icon]
  end

  def destination_path
    admin_report_path(id: record.id)
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
