class ProfilesController < ApplicationController
  before_action :auth_user

  def index
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to profiles_path, notice: 'Profile updated successfully.'
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, author_attributes: [:id, :nickname, :avatar])
  end

  def auth_user
    unless user_signed_in?
      flash[:info] = t('auth.not_signed_in')
      redirect_to root_path
    end
  end
end
