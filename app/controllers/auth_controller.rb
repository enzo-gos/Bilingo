class AuthController < ApplicationController
  def index; end

  def sign_in
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('auth-modal-title') { 'Login in to Bilingo' },
          turbo_stream.update('auth-modal-body', partial: 'auth/modal_body/sign_in')
        ]
      end
    end
  end

  def sign_up
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('auth-modal-title') { 'Join Bilingo' },
          turbo_stream.update('auth-modal-body', partial: 'auth/modal_body/sign_up')
        ]
      end
    end
  end

  def logout; end
end
