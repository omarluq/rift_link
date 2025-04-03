# frozen_string_literal: true

module Views
  module Sessions
    class New < Views::Base
      prop :alert, _Nilable(String)
      prop :notice, _Nilable(String)
      prop :params, ActionController::Parameters
      attr_reader :alert, :notice, :params

      def view_template
        div(class: 'min-h-screen bg-gradient-to-br from-zinc-900 via-indigo-950 to-purple-950 flex flex-col justify-center py-12 sm:px-6 lg:px-8 relative overflow-hidden') do
          # Animated background elements
          render_animated_background

          # Main content container with glassmorphism effect
          div(class: 'relative z-10 max-w-md mx-auto bg-white/10 backdrop-blur-xl rounded-xl shadow-2xl overflow-hidden border border-white/20') do
            div(class: 'px-8 pt-8 pb-10') do
              logo
              toast
              heading
              form
              footing
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

      def toast
        if notice
          div(class: 'mb-6 p-4 bg-green-500/10 border border-green-500/30 rounded-md backdrop-blur-sm') do
            div(class: 'flex items-center') do
              Lucide::CircleCheck class: 'h-5 w-5 mr-2 text-green-400'
              p(class: 'text-sm text-green-100') { notice }
            end
          end
        end

        if alert
          div(class: 'mb-6 p-4 bg-red-500/10 border border-red-500/30 rounded-md backdrop-blur-sm') do
            div(class: 'flex items-center') do
              Lucide::CircleAlert class: 'h-5 w-5 mr-2 text-red-400'
              p(class: 'text-sm text-red-100') { alert }
            end
          end
        end
      end

      def heading
        h1(class: 'text-center text-3xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-cyan-200 to-white mb-2') do
          'Welcome Back'
        end
        p(class: 'text-center text-cyan-200/70 text-sm mb-8') do
          'Enter your credentials to continue'
        end
      end

      def form
        form_with(url: sign_in_path, class: 'space-y-6') do |form|
          div(class: 'space-y-5') do
            # Email field
            div do
              div(class: 'flex items-center justify-between mb-1') do
                form.label :email, 'Email', class: 'block text-sm font-medium text-cyan-100'
              end
              div(class: 'relative group') do
                div(class: 'absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none') do
                  Lucide::Mail class: 'h-5 w-5 text-indigo-300'
                end
                form.email_field :email,
                  value: params[:email_hint],
                  required: true,
                  autofocus: true,
                  autocomplete: 'email',
                  placeholder: 'you@example.com',
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
                  Lucide::Lock class: 'h-5 w-5 text-indigo-300'
                end
                form.password_field :password,
                  required: true,
                  autocomplete: 'current-password',
                  placeholder: '••••••••',
                  class: 'block w-full pl-10 pr-3 py-3 border border-white/10 rounded-lg bg-white/5 placeholder-indigo-300/50 text-white text-sm
                          focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:border-transparent
                          transition duration-200 hover:bg-white/10'
              end
            end

            # Sign-in button with hover effect
            div(class: 'pt-2') do
              form.submit 'Sign in',
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

      def footing
        div(class: 'mt-8 flex flex-col items-center justify-center space-y-4 text-sm') do
          link_to 'Forgot your password?',
            new_identity_password_reset_path,
            class: 'font-medium text-cyan-300 hover:text-white transition-colors'

          # Optional: Add sign-up link if needed
          p(class: 'text-indigo-300/70') do
            span { "Don't have an account? " }
            link_to 'Sign up',
              sign_up_path, # Replace with your sign-up path
              class: 'font-medium text-cyan-300 hover:text-white transition-colors'
          end
        end
      end
    end
  end
end
