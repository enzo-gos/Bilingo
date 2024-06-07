class AuthController < ApplicationController
  def index; end

  def sign_in
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('auth-modal-title') { t('auth.sign_in.title') },
          turbo_stream.update('auth-modal-body', partial: 'auth/modal_body/sign_in')
        ]
      end
    end
  end

  def sign_up
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('auth-modal-title') { t('auth.sign_up.title') },
          turbo_stream.update('auth-modal-body', partial: 'auth/modal_body/sign_up')
        ]
      end
    end
  end

  def logout; end
end
