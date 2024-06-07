class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  protect_from_forgery

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include Pagy::Backend

  private

  def user_not_authorized
    flash[:notice] = 'You are not authorized to perform this action.'
    # redirect_to dashboard_path
  end
end
