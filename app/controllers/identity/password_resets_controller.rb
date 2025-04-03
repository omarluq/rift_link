# frozen_string_literal: true

module Identity
  class PasswordResetsController < ApplicationController
    skip_before_action :authenticate

    before_action :set_user, only: %i[edit update]

    def new
      render Views::Identity::PasswordResets::New.new(alert:)
    end

    def edit
      render Views::Identity::PasswordResets::Edit.new(user: @user, params:)
    end

    def create
      if (@user = User.find_by(email: params[:email], verified: true))
        send_password_reset_email
        redirect_to sign_in_path, notice: 'Check your email for reset instructions'
      else
        redirect_to new_identity_password_reset_path, alert: "You can't reset your password until you verify your email"
      end
    end

    def update
      if @user.update(user_params)
        redirect_to sign_in_path, notice: 'Your password was reset successfully. Please sign in'
      else
        render Views::Identity::PasswordResets::Edit.new(user: @user, params:), status: :unprocessable_entity
      end
    end

  private

    def set_user
      @user = User.find_by_token_for!(:password_reset, params[:sid])
    rescue
      redirect_to new_identity_password_reset_path, alert: 'That password reset link is invalid'
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end

    def send_password_reset_email
      UserMailer.with(user: @user).password_reset.deliver_later
    end
  end
end
