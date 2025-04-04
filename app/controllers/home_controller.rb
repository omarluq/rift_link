# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render Views::Home::Index.new(activities:, realms:, flash:)
  end

  def show
    render Views::Home::Show.new(flash:)
  end

  def sidenav
    render Views::Home::Sidenav.new(realms:, pinned_realms:, my_realms:, direct_messages:)
  end

  def settings
    @user_profile = Current.user.profile || UserProfile.new(user: Current.user)
    render Views::Home::Settings.new(user: Current.user, user_profile: @user_profile, flash:)
  end

  def update_profile
    @user_profile = Current.user.profile || UserProfile.new(user: Current.user)

    if @user_profile.update(profile_params)
      redirect_to settings_path, notice: 'Profile updated successfully'
    else
      render Views::Home::Settings.new(user: Current.user, user_profile: @user_profile, flash:), status: :unprocessable_entity
    end
  end

  def update_account
    @user = Current.user

    if @user.authenticate(account_params[:password_challenge])
      if account_params[:email].present? && @user.email != account_params[:email]
        @user.email = account_params[:email]
        @user.verified = false
        send_email_verification if @user.save
        redirect_to settings_path, notice: 'Email updated successfully. Please verify your new email address.'
      elsif account_params[:password].present?
        @user.password = account_params[:password]
        @user.password_confirmation = account_params[:password_confirmation]
        @user.save ? redirect_to(settings_path, notice: 'Password updated successfully') : render(Views::Home::Settings.new(user: @user, user_profile: @user.profile, flash:), status: :unprocessable_entity)
      else
        redirect_to settings_path, notice: 'No changes made to your account'
      end
    else
      @user.errors.add(:password_challenge, 'is incorrect')
      render Views::Home::Settings.new(user: @user, user_profile: @user.profile, flash:), status: :unprocessable_entity
    end
  end

private

  def profile_params
    params.require(:user_profile).permit(:username, :display_name, :bio, :gaming_status)
  end

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation, :password_challenge)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end

  def realms
    @realms ||= Realm.left_joins(:memberships)
      .select('realms.*, COUNT(memberships.id) as member_count')
      .where(is_public: true)
      .group('realms.id')
      .order(Arel.sql('COUNT(memberships.id) DESC'))
      .limit(6)
  end

  def pinned_realms
    @pinned_realms ||= Current.user.realms
      .joins(:memberships)
      .where(memberships: { user_id: Current.user.id })
      .select('realms.*, memberships.joined_at')
      .order(Arel.sql('memberships.joined_at ASC'))
      .limit(2)
  end

  def my_realms
    @my_realms ||= Current.user.realms
      .where.not(id: pinned_realms.map(&:id))
      .limit(5)
  end

  def direct_messages
    @direct_messages ||= DirectMessageThread
      .joins(:participants)
      .where(direct_message_participants: { user_id: Current.user.id })
      .joins("LEFT JOIN (
      SELECT messageable_id, MAX(created_at) as last_message_at
      FROM messages
      WHERE messageable_type = 'DirectMessageThread'
      GROUP BY messageable_id
    ) latest_messages ON latest_messages.messageable_id = direct_message_threads.id")
      .select('direct_message_threads.*, COALESCE(latest_messages.last_message_at, direct_message_threads.created_at) as sort_date')
      .order(Arel.sql('sort_date DESC'))
      .limit(3)
  end

  def activities
    @activities ||= Activity
      .includes(:user)
      .order(created_at: :desc)
      .limit(5)
  end
end
