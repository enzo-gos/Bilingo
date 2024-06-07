class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :set_locale
  protect_from_forgery

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include Pagy::Backend

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def user_not_authorized
    flash[:notice] = 'You are not authorized to perform this action.'
    # redirect_to dashboard_path
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
