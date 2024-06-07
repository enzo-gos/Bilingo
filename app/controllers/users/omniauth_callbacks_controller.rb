class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = filter_auth_data(auth)
      redirect_to root_path, alert: I18n.t('devise.omniauth_callbacks.facebook_error')
    end
  rescue OmniAuth::Strategies::OAuth2::CallbackError => e
    Rails.logger.error("Omniauth Facebook OAuth2 callback error: #{e.message}")
    redirect_to root_path, alert: I18n.t('devise.omniauth_callbacks.callback_error', provider: 'Facebook')
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("User record invalid: #{e.message}")
    redirect_to root_path, alert: I18n.t('devise.omniauth_callbacks.record_invalid')
  rescue StandardError => e
    Rails.logger.error("Unexpected error during Facebook authentication: #{e.message}")
    redirect_to root_path, alert: I18n.t('devise.omniauth_callbacks.unexpected_error')
  end

  def failure
    redirect_to root_path, alert: I18n.t('devise.omniauth_callbacks.failure')
  end

  private

  def filter_auth_data(auth)
    auth.except(:extra, :credentials, :info).tap do |filtered_auth|
      filtered_auth['info'] = auth['info'].slice('name', 'email')
    end
  end
end
