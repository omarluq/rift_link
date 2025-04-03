# frozen_string_literal: true

class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def new
    @user = User.new
    render Views::Registrations::New.new(user: @user)
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)

      if @user.save
        # Create the associated user profile
        @user_profile = UserProfile.new(user_profile_params)
        @user_profile.user = @user
        @user_profile.gaming_status = 'offline' # Default status

        if @user_profile.save
          # Handle successful registration
          session_record = @user.sessions.create!
          cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }
          send_email_verification
          redirect_to root_path, notice: 'Welcome to RiftLink! Your account has been created successfully.'
          return # Exit early to avoid transaction issues
        else
          # Add profile errors to user for display
          @user_profile.errors.each do |error|
            @user.errors.add(:base, "Profile #{error.attribute} #{error.message}")
          end
          raise ActiveRecord::Rollback # Roll back the transaction
        end
      end

      # If we get here, either user or profile creation failed
      render Views::Registrations::New.new(user: @user), status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def user_profile_params
    params.permit(:username)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
