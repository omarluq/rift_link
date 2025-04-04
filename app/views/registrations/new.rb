# frozen_string_literal: true

module Views
  module Registrations
    class New < Views::Base
      include Phlex::Rails::Helpers::Pluralize
      prop :user, User, reader: :private

      def view_template
        div(class: 'min-h-screen flex flex-col justify-center py-12 sm:px-6 lg:px-8 relative overflow-hidden') do
          # Animated background elements
          render_animated_background

          # Main content container with glassmorphism effect
          div(class: 'relative z-10 max-w-md mx-auto bg-white/10 backdrop-blur-xl rounded-xl shadow-2xl overflow-hidden border border-white/20') do
            div(class: 'px-8 pt-8 pb-10') do
              logo
              render_errors
              heading
              sign_up_form
              footer_links
            end
          end
        end
      end

      def render_animated_background
        div(class: 'absolute inset-0 overflow-hidden') do
          # Portal/rift effect circles
          div(class: 'absolute -top-20 -right-20 w-64 h-64 bg-purple-500/30 rounded-full blur-3xl animate-pulse')
          div(class: 'absolute -bottom-32 -left-20 w-80 h-80 bg-blue-500/20 rounded-full blur-3xl animate-pulse delay-700')
          div(class: 'absolute top-1/4 left-1/3 w-40 h-40 bg-cyan-500/20 rounded-full blur-2xl animate-pulse delay-1000')

          # Grid lines effect (optional)
          div(class: 'absolute inset-0 bg-grid-white/[0.03] bg-[size:30px_30px]')
        end
      end

      def logo
        div(class: 'flex justify-center mb-6') do
          div(class: 'text-white text-3xl font-bold tracking-wider flex items-center') do
            span(class: 'text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-purple-500') { 'RIFT' }
            span(class: 'text-white') { 'LINK' }
          end
        end
      end

      def render_errors
        if user.errors.any?
          div(class: 'mb-6 p-4 bg-red-500/10 border border-red-500/30 rounded-md backdrop-blur-sm') do
            h2(class: 'text-red-300 text-sm font-medium flex items-center mb-2') do
              render Lucide::TriangleAlert class: 'h-4 w-4 mr-2 text-red-400'
              span do
                pluralize(user.errors.count, 'error')
                ' prohibited sign up:'
              end
            end
            ul(class: 'list-disc pl-5 text-red-200 text-sm space-y-1') do
              user.errors.each { |error| li { error.full_message } }
            end
          end
        end
      end

      def heading
        h1(class: 'text-center text-3xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-cyan-200 to-white mb-2') do
          'Join RiftLink'
        end
        p(class: 'text-center text-cyan-200/70 text-sm mb-8') do
          'Create your account to connect with gamers'
        end
      end

      def sign_up_form
        form_with(url: sign_up_path, class: 'space-y-5') do |form|
          div(class: 'space-y-5') do
            # Email field
            div do
              div(class: 'flex items-center justify-between mb-1') do
                form.label :email, 'Email', class: 'block text-sm font-medium text-cyan-100'
              end
              div(class: 'relative group') do
                div(class: 'absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none') do
                  render Lucide::Mail class: 'h-5 w-5 text-indigo-300'
                end
                form.email_field :email,
                  value: user.email,
                  required: true,
                  autofocus: true,
                  autocomplete: 'email',
                  placeholder: 'your@email.com',
                  class: 'block w-full pl-10 pr-3 py-3 border border-white/10 rounded-lg bg-white/5 placeholder-indigo-300/50 text-white text-sm
                          focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:border-transparent
                          transition duration-200 hover:bg-white/10'
              end
            end

            # Password field
            div do
              div(class: 'flex items-center justify-between mb-1') do
                form.label :password, 'Password', class: 'block text-sm font-medium text-cyan-100'
              end
              div(class: 'relative group') do
                div(class: 'absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none') do
                  render Lucide::Lock class: 'h-5 w-5 text-indigo-300'
                end
                form.password_field :password,
                  required: true,
                  autocomplete: 'new-password',
                  placeholder: '••••••••••••',
                  class: 'block w-full pl-10 pr-3 py-3 border border-white/10 rounded-lg bg-white/5 placeholder-indigo-300/50 text-white text-sm
                          focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:border-transparent
                          transition duration-200 hover:bg-white/10'
              end
              div(class: 'mt-1 text-xs text-cyan-300/70') do
                render Lucide::Info class: 'h-3 w-3 inline mr-1 text-cyan-300/70'
                '12 characters minimum recommended.'
              end
            end

            # Password confirmation field
            div do
              div(class: 'flex items-center justify-between mb-1') do
                form.label :password_confirmation, 'Confirm Password', class: 'block text-sm font-medium text-cyan-100'
              end
              div(class: 'relative group') do
                div(class: 'absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none') do
                  render Lucide::ShieldCheck class: 'h-5 w-5 text-indigo-300'
                end
                form.password_field :password_confirmation,
                  required: true,
                  autocomplete: 'new-password',
                  placeholder: '••••••••••••',
                  class: 'block w-full pl-10 pr-3 py-3 border border-white/10 rounded-lg bg-white/5 placeholder-indigo-300/50 text-white text-sm
                          focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:border-transparent
                          transition duration-200 hover:bg-white/10'
              end
            end

            # Username field (added as a gaming platform needs usernames)
            div do
              div(class: 'flex items-center justify-between mb-1') do
                form.label :username, 'Username', class: 'block text-sm font-medium text-cyan-100'
              end
              div(class: 'relative group') do
                div(class: 'absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none') do
                  render Lucide::User class: 'h-5 w-5 text-indigo-300'
                end
                form.text_field :username,
                  required: true,
                  placeholder: 'YourGamerTag',
                  class: 'block w-full pl-10 pr-3 py-3 border border-white/10 rounded-lg bg-white/5 placeholder-indigo-300/50 text-white text-sm
                          focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:border-transparent
                          transition duration-200 hover:bg-white/10'
              end
            end

            # Terms and Privacy Agreement
            div(class: 'flex items-start mt-4') do
              div(class: 'flex items-center h-5') do
                form.check_box :terms_agreement,
                  required: true,
                  class: 'h-4 w-4 text-cyan-500 border border-white/30 rounded focus:ring-cyan-400/50 focus:ring-offset-zinc-900 bg-white/5'
              end
              div(class: 'ml-3 text-sm') do
                form.label :terms_agreement, class: 'text-cyan-200/70' do
                  span { 'I agree to the ' }
                  link_to 'Terms of Service', '#', class: 'text-cyan-300 hover:text-cyan-200 underline'
                  span { ' and ' }
                  link_to 'Privacy Policy', '#', class: 'text-cyan-300 hover:text-cyan-200 underline'
                end
              end
            end

            # Sign-up button with hover effect
            div(class: 'pt-4') do
              form.submit 'Create Account',
                class: 'w-full relative inline-flex justify-center items-center px-4 py-3 rounded-lg overflow-hidden
                         text-white font-medium text-sm
                         bg-gradient-to-r from-cyan-500 to-purple-600 hover:from-cyan-400 hover:to-purple-500
                         shadow-lg shadow-cyan-500/20
                         focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-indigo-900 focus:ring-cyan-400
                         transform transition-all duration-200 hover:scale-[1.02]'
            end
          end
        end
      end

      def footer_links
        div(class: 'mt-8 flex flex-col items-center justify-center space-y-4 text-sm') do
          p(class: 'text-indigo-300/70') do
            span { 'Already have an account? ' }
            link_to 'Sign in',
              sign_in_path,
              class: 'font-medium text-cyan-300 hover:text-white transition-colors'
          end
        end
      end
    end
  end
end
