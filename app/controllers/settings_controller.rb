# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :set_user_profile

  def index
    render Views::Settings::Index.new(
      user: Current.user,
      user_profile: @user_profile,
      active_tab: params[:tab] || 'profile',
      flash:
    )
  end

  def profile
    render Components::ProfileSettings.new(user_profile: @user_profile)
  end

  def account
    render Components::AccountSettings.new(user: Current.user)
  end

  def sessions
    render Components::SessionSettings.new(user: Current.user)
  end

  def danger
    render Components::DangerZoneSettings.new(user: Current.user)
  end

  def update_profile
    if @user_profile.update(profile_params)
      flash.notice = 'Profile updated successfully'
      render Components::ProfileSettings.new(user_profile: @user_profile)
    else
      render Components::ProfileSettings.new(user_profile: @user_profile), status: :unprocessable_entity
    end
  end

  def update_account
    @user = Current.user

    if @user.authenticate(account_params[:password_challenge])
      if account_params[:email].present? && @user.email != account_params[:email]
        @user.email = account_params[:email]
        @user.verified = false
        send_email_verification if @user.save
        redirect_to settings_path(tab: 'account'), notice: 'Email updated successfully. Please verify your new email address.'
      elsif account_params[:password].present?
        @user.password = account_params[:password]
        @user.password_confirmation = account_params[:password_confirmation]
        if @user.save
          redirect_to settings_path(tab: 'account'), notice: 'Password updated successfully'
        else
          render Components::AccountSettings.new(user: @user), status: :unprocessable_entity
        end
      else
        redirect_to settings_path(tab: 'account'), notice: 'No changes made to your account'
      end
    else
      @user.errors.add(:password_challenge, 'is incorrect')
      render Components::AccountSettings.new(user: @user), status: :unprocessable_entity
    end
  end

  private

  def set_user_profile
    @user_profile = Current.user.profile || UserProfile.new(user: Current.user)
  end

  def profile_params
    params.require(:user_profile).permit(:username, :display_name, :bio, :gaming_status)
  end

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation, :password_challenge)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
