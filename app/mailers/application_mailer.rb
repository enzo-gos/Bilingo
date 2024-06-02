class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_SERVICE_SENDER']
  layout 'mailer'
end
