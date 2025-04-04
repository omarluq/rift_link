# frozen_string_literal: true

module Components
  class AccountSettings < Components::Base
    prop :user, User, reader: :private

    def view_template
      turbo_frame_tag 'settings-account-content' do
        div(class: 'flex flex-row gap-2 align-center') do
          RubyUI::Heading(level: 2, class: 'mb-6 flex items-center') do
            Lucide::Shield class: 'h-5 w-5 mr-2 text-cyan-400'
            'Account Settings'
          end
          RubyUI::Text(as: 'p', class: 'mb-6 text-white/60') do
            'Manage your email and password'
          end
        end
        render_form
      end
    end

    private

    def render_form
      form_with(model: user, url: update_account_path, method: :patch, class: 'space-y-6') do |form|
        # Email Card
        RubyUI::Card(class: 'mb-6') do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Email Address' }
          end
          RubyUI::CardContent() do
            div(class: 'mt-4') do
              form.email_field :email,
                class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/40 focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50',
                required: true,
                autocomplete: 'email'
              if user.verified?
                render_verified_badge
              else
                render_unverified_badge
              end
            end
          end
        end

        # Password Card
        RubyUI::Card(class: 'mb-6') do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Change Password' }
            RubyUI::CardDescription() { 'Update your password to maintain security' }
          end
          RubyUI::CardContent() do
            div(class: 'grid gap-4 mt-4') do
              div do
                RubyUI::Text(as: 'label', for: 'user_password', weight: 'medium', size: 'sm') do
                  'New Password'
                end
                form.password_field :password,
                  class: 'mt-1 w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/40 focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50',
                  placeholder: '••••••••••••'
                if user.errors[:password].any?
                  div(class: 'mt-1 text-red-400 text-sm') { user.errors[:password].join(', ') }
                else
                  div(class: 'mt-1 text-white/50 text-xs') { '12 characters minimum recommended.' }
                end
              end

              div do
                RubyUI::Text(as: 'label', for: 'user_password_confirmation', weight: 'medium', size: 'sm') do
                  'Confirm New Password'
                end
                form.password_field :password_confirmation,
                  class: 'mt-1 w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/40 focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50',
                  placeholder: '••••••••••••'
                if user.errors[:password_confirmation].any?
                  div(class: 'mt-1 text-red-400 text-sm') { user.errors[:password_confirmation].join(', ') }
                end
              end
            end
          end
        end

        # Current Password
        RubyUI::Card(class: 'mb-6') do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Current Password' }
            RubyUI::CardDescription() { 'Required to save changes to your account' }
          end
          RubyUI::CardContent() do
            div(class: 'mt-4') do
              form.password_field :password_challenge, required: true,
                class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/40 focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50',
                placeholder: 'Enter your current password'
              if user.errors[:password_challenge].any?
                div(class: 'mt-1 text-red-400 text-sm') { user.errors[:password_challenge].join(', ') }
              end
            end
          end
        end

        div(class: 'flex justify-end') do
          RubyUI::Button(variant: :primary, type: :submit) do
            'Update Account'
          end
        end
      end
    end

    def render_verified_badge
      div(class: 'mt-1 text-green-400 text-xs flex items-center') do
        Lucide::CircleCheck class: 'h-3 w-3 mr-1'
        'Verified'
      end
    end

    def render_unverified_badge
      div(class: 'mt-2 flex items-center justify-between') do
        div(class: 'text-amber-400 text-xs flex items-center') do
          Lucide::CircleAlert class: 'h-3 w-3 mr-1'
          'Not verified'
        end
        link_to 'Resend verification email',
          identity_email_verification_path,
          class: 'text-xs text-cyan-300 hover:text-cyan-200 underline',
          data: { turbo_method: :post }
      end
    end
  end
end
