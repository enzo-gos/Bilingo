class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :set_locale
  before_action :set_default_parser
  protect_from_forgery

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include Pagy::Backend

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  private

  def user_not_authorized
    flash[:notice] = 'You are not authorized to perform this action.'
    # redirect_to dashboard_path
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_default_parser
    ActsAsTaggableOn.default_parser = ActsAsTaggableOn::DefaultParser
  end
end
