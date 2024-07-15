class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_report.subject
  #
  def new_report
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
