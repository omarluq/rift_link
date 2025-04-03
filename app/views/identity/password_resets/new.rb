# frozen_string_literal: true

module Views
  module Identity
    module PasswordResets
      class New < Views::Base
        prop :alert, _Nilable(String)
        attr_reader :alert

        def view_template
          div(class: 'min-h-screen flex flex-col justify-center py-12 sm:px-6 lg:px-8 relative overflow-hidden') do
            # Animated background elements
            render_animated_background

            # Main content container with glassmorphism effect
            div(class: 'relative z-10 max-w-md mx-auto bg-white/10 backdrop-blur-xl rounded-xl shadow-2xl overflow-hidden border border-white/20') do
              div(class: 'px-8 pt-8 pb-10') do
                logo
                render_alert if alert
                heading
                password_reset_form
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

        def render_alert
          div(class: 'mb-6 p-4 bg-red-500/10 border border-red-500/30 rounded-md backdrop-blur-sm') do
            div(class: 'flex items-center') do
              render Lucide::CircleAlert class: 'h-5 w-5 mr-2 text-red-400'
              p(class: 'text-sm text-red-100') { alert }
            end
          end
        end

        def heading
          h1(class: 'text-center text-3xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-cyan-200 to-white mb-2') do
            'Reset Password'
          end
          p(class: 'text-center text-cyan-200/70 text-sm mb-8') do
            'Enter your email to receive a password reset link'
          end
        end

        def password_reset_form
          form_with(url: identity_password_reset_path, class: 'space-y-6') do |form|
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
                    required: true,
                    autofocus: true,
                    autocomplete: 'email',
                    placeholder: 'Enter your account email',
                    class: 'block w-full pl-10 pr-3 py-3 border border-white/10 rounded-lg bg-white/5 placeholder-indigo-300/50 text-white text-sm
                            focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:border-transparent
                            transition duration-200 hover:bg-white/10'
                end
              end

              # Reset button with hover effect
              div(class: 'pt-2') do
                form.submit 'Send Reset Link',
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
          div(class: 'mt-8 flex items-center justify-center space-x-4 text-sm') do
            link_to sign_in_path, class: 'font-medium text-cyan-300 hover:text-white transition-colors flex items-center' do
              render Lucide::LogIn class: 'h-4 w-4 mr-1 text-cyan-300'
              span { 'Sign in' }
            end

            div(class: 'h-4 w-px bg-white/20')

            link_to sign_up_path, class: 'font-medium text-cyan-300 hover:text-white transition-colors flex items-center' do
              render Lucide::UserPlus class: 'h-4 w-4 mr-1 text-cyan-300'
              span { 'Sign up' }
            end
          end

          div(class: 'mt-4 text-center') do
            div(class: 'text-indigo-300/50 text-xs') do
              'We\'ll send instructions to reset your password'
            end
          end
        end
      end
    end
  end
end
