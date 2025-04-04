# frozen_string_literal: true

module Views
  module Home
    class Settings < Views::Base
      prop :user, User, reader: :private
      prop :user_profile, UserProfile, reader: :private

      def view_template
        div(class: 'container mx-auto p-6') do
          div(class: 'flex flex-row items-center mb-6') do
            Components::Logo()
          end
          div(class: 'grid grid-cols-1 lg:grid-cols-3 gap-8') do
            div(class: 'lg:col-span-2 space-y-8') do
              render_profile_form
              render_account_form
            end

            div(class: 'lg:col-span-1') do
              render_sidebar
            end
          end
        end
      end

      private

      def render_profile_form
        RubyUI::Card() do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Profile Settings' }
            RubyUI::CardDescription() { 'Update your personal information and gaming status' }
          end

          RubyUI::CardContent() do
            form_with(model: user_profile, url: update_profile_path, method: :patch, class: 'space-y-4') do |form|
              div(class: 'flex items-center space-x-4') do
                div(class: 'relative h-16 w-16 rounded-full bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center overflow-hidden') do
                  if user_profile.avatar.present?
                    img(src: user_profile.avatar_url, alt: "#{user.username}'s avatar", class: 'w-full h-full object-cover')
                  else
                    span(class: 'text-white text-xl font-bold') { user_profile.username ? user_profile.username[0..1].upcase : '??' }
                  end
                end

                div do
                  # In a real implementation, this would handle file uploads
                  button(type: 'button', class: 'mt-2 py-1 px-3 text-sm bg-cyan-500 hover:bg-cyan-600 text-white rounded-md transition-colors') do
                    'Upload Avatar'
                  end
                end
              end

              div do
                form.label :username, 'Username', class: 'block text-sm font-medium text-white mb-1'
                form.text_field :username, class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/50 focus:outline-none focus:ring-1 focus:ring-cyan-400'
                if user_profile.errors[:username].any?
                  div(class: 'mt-1 text-red-400 text-sm') { user_profile.errors[:username].join(', ') }
                end
              end

              div do
                form.label :display_name, 'Display Name', class: 'block text-sm font-medium text-white mb-1'
                form.text_field :display_name, class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/50 focus:outline-none focus:ring-1 focus:ring-cyan-400'
              end

              div do
                form.label :bio, 'Bio', class: 'block text-sm font-medium text-white mb-1'
                form.text_area :bio, rows: 3, class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/50 focus:outline-none focus:ring-1 focus:ring-cyan-400'
              end

              # div do
              #   form.label :gaming_status, 'Gaming Status', class: 'block text-sm font-medium text-white mb-1'
              #   form.select :gaming_status,
              #     options_for_select([
              #       ['Online', 'online'],
              #       ['Away', 'away'],
              #       ['Busy', 'busy'],
              #       ['Offline', 'offline'],
              #     ], user_profile.gaming_status),
              #     {},
              #     class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white focus:outline-none focus:ring-1 focus:ring-cyan-400'
              # end

              div do
                form.submit 'Save Changes', class: 'w-full bg-gradient-to-r from-cyan-500 to-purple-600 hover:from-cyan-400 hover:to-purple-500 text-white font-medium py-2 px-4 rounded-md transition-colors shadow-lg'
              end
            end
          end
        end
      end

      def render_account_form
        RubyUI::Card() do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Account Settings' }
            RubyUI::CardDescription() { 'Update your email address and password' }
          end

          RubyUI::CardContent() do
            form_with(model: user, url: update_account_path, method: :patch, class: 'space-y-4') do |form|
              div do
                form.label :email, 'Email Address', class: 'block text-sm font-medium text-white mb-1'
                form.email_field :email, class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/50 focus:outline-none focus:ring-1 focus:ring-cyan-400'

                if user.verified?
                  div(class: 'mt-1 text-green-400 text-xs flex items-center') do
                    Lucide::CircleCheck class: 'h-3 w-3 mr-1'
                    'Verified'
                  end
                else
                  div(class: 'mt-1 text-amber-400 text-xs flex items-center') do
                    Lucide::CircleAlert class: 'h-3 w-3 mr-1'
                    'Not verified'
                    button_to 'Resend verification email',
                      identity_email_verification_path,
                      class: 'ml-2 underline text-cyan-300',
                      form_class: 'inline'
                  end
                end
              end

              div do
                form.label :password, 'New Password', class: 'block text-sm font-medium text-white mb-1'
                form.password_field :password, class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/50 focus:outline-none focus:ring-1 focus:ring-cyan-400'
                if user.errors[:password].any?
                  div(class: 'mt-1 text-red-400 text-sm') { user.errors[:password].join(', ') }
                end
              end

              div do
                form.label :password_confirmation, 'Confirm New Password', class: 'block text-sm font-medium text-white mb-1'
                form.password_field :password_confirmation, class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/50 focus:outline-none focus:ring-1 focus:ring-cyan-400'
                if user.errors[:password_confirmation].any?
                  div(class: 'mt-1 text-red-400 text-sm') { user.errors[:password_confirmation].join(', ') }
                end
              end

              div(class: 'border-t border-white/10 pt-4 mt-4') do
                form.label :password_challenge, 'Current Password', class: 'block text-sm font-medium text-white mb-1'
                form.password_field :password_challenge, required: true, class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/50 focus:outline-none focus:ring-1 focus:ring-cyan-400'
                div(class: 'mt-1 text-white/50 text-xs') { 'Required to save changes to your account' }
                if user.errors[:password_challenge].any?
                  div(class: 'mt-1 text-red-400 text-sm') { user.errors[:password_challenge].join(', ') }
                end
              end

              div do
                form.submit 'Update Account', class: 'w-full bg-gradient-to-r from-cyan-500 to-purple-600 hover:from-cyan-400 hover:to-purple-500 text-white font-medium py-2 px-4 rounded-md transition-colors shadow-lg'
              end
            end
          end
        end
      end

      def render_sidebar
        div(class: 'space-y-6') do
          render_session_management
          render_danger_zone
        end
      end

      def render_session_management
        RubyUI::Card() do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Active Sessions' }
            RubyUI::CardDescription() { 'You are currently logged in on these devices' }
          end

          RubyUI::CardContent() do
            div(class: 'space-y-4') do
              user.sessions.order(created_at: :desc).limit(3).each do |session|
                render_session_item(session)
              end

              if user.sessions.count > 3
                link_to sessions_path, class: 'text-sm text-cyan-300 hover:underline' do
                  'View all sessions'
                end
              end
            end
          end
        end
      end

      def render_session_item(session)
        div(class: 'flex items-start justify-between p-3 rounded-md bg-white/5') do
          div(class: 'flex-1') do
            div(class: 'flex items-center') do
              if session == Current.session
                div(class: 'h-2 w-2 rounded-full bg-green-500 mr-2')
                span(class: 'text-white font-medium') { 'Current session' }
              else
                div(class: 'h-2 w-2 rounded-full bg-white/50 mr-2')
                span(class: 'text-white/70') { 'Active session' }
              end
            end

            p(class: 'text-xs text-white/50 mt-1 truncate') { session.user_agent }
            p(class: 'text-xs text-white/50') do
              "Last active: #{time_ago_in_words(session.updated_at)} ago"
            end
          end

          unless session == Current.session
            button_to session_path(session),
              method: :delete,
              class: 'px-2 py-1 bg-red-500/20 hover:bg-red-500/30 text-red-300 rounded text-xs transition-colors' do
              'Log out'
            end
          end
        end
      end

      def render_danger_zone
        RubyUI::Card() do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Danger Zone' }
            RubyUI::CardDescription() { 'Permanent actions for your account' }
          end

          RubyUI::CardContent() do
            div(class: 'space-4') do
              div(class: 'p-3 rounded-md bg-red-500/10 border border-red-500/20') do
                h3(class: 'text-red-300 font-medium') { 'Delete Account' }
                p(class: 'text-white/60 text-sm mt-1') { 'Once you delete your account, there is no going back. Please be certain.' }

                button(type: 'button', class: 'mt-3 w-full bg-red-500/20 hover:bg-red-500/30 text-red-300 py-2 px-4 rounded-md transition-colors') do
                  'Delete Account'
                end
              end
            end
          end
        end
      end
    end
  end
end
