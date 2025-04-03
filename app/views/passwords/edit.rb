# frozen_string_literal: true

module Views
  module Passwords
    class Edit < Views::Base
      prop :alert, _Nilable(String)
      prop :user, User
      attr_accessor :alert, :user

      def view_template
        div(class: 'min-h-screen bg-white dark:bg-zinc-900 flex flex-col justify-center py-12 sm:px-6 lg:px-8') do
          div(class: 'max-w-md mx-auto') do
            if alert
              p(class: 'mb-6 p-4 text-destructive bg-destructive/10 border border-destructive/20 rounded-md') { alert }
            end

            h1(class: 'text-center text-3xl font-bold text-zinc-900 dark:text-zinc-50 mb-8') { 'Change your password' }

            form_with(url: password_path, method: :patch, class: 'mt-8 space-y-6') do |form|
              if @user.errors.any?
                div(class: 'bg-destructive/10 border-l-4 border-destructive p-4 mb-6 rounded-r-md') do
                  h2(class: 'text-destructive dark:text-destructive-foreground text-lg font-medium mb-2') do
                    pluralize(@user.errors.count, 'error')
                    ' prohibited this user from being saved:'
                  end
                  ul(class: 'list-disc pl-5 text-destructive dark:text-destructive-foreground/90') do
                    @user.errors.each { |error| li { error.full_message } }
                  end
                end
              end

              div(class: 'space-y-4') do
                div do
                  form.label(:password,
                    class: 'block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-1')
                  form.password_field(:password_challenge,
                    required: true,
                    autofocus: true,
                    autocomplete: 'current-password',
                    class: 'appearance-none block w-full px-3 py-2
                      border border-secondary/20 dark:border-secondary/10 rounded-md shadow-sm
                      placeholder-zinc-400 dark:placeholder-zinc-600
                      bg-white dark:bg-zinc-800
                      text-zinc-900 dark:text-zinc-100
                      focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary/50
                      dark:focus:ring-primary/40 dark:focus:border-primary/40')
                end

                div do
                  form.label(:password,
                    'New password',
                    class: 'block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-1')
                  form.password_field(:password,
                    required: true,
                    autocomplete: 'new-password',
                    class: 'appearance-none block w-full px-3 py-2
                      border border-secondary/20 dark:border-secondary/10 rounded-md shadow-sm
                      placeholder-zinc-400 dark:placeholder-zinc-600
                      bg-white dark:bg-zinc-800
                      text-zinc-900 dark:text-zinc-100
                      focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary/50
                      dark:focus:ring-primary/40 dark:focus:border-primary/40')
                  div(class: 'mt-1 text-sm text-zinc-500 dark:text-zinc-400') { '12 characters minimum.' }
                end

                div do
                  form.label(:password_confirmation,
                    'Confirm new password',
                    class: 'block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-1')
                  form.password_field(:password_confirmation,
                    required: true,
                    autocomplete: 'new-password',
                    class: 'appearance-none block w-full px-3 py-2
                      border border-secondary/20 dark:border-secondary/10 rounded-md shadow-sm
                      placeholder-zinc-400 dark:placeholder-zinc-600
                      bg-white dark:bg-zinc-800
                      text-zinc-900 dark:text-zinc-100
                      focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary/50
                      dark:focus:ring-primary/40 dark:focus:border-primary/40')
                end

                div(class: 'mt-6') do
                  form.submit('Save changes',
                    class: 'w-full flex justify-center py-2 px-4
                      border border-transparent rounded-md shadow-sm
                      text-sm font-medium text-white
                      bg-primary hover:bg-primary/90
                      focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary
                      dark:focus:ring-offset-zinc-900
                      transition-colors')
                end
              end
            end
          end
        end
      end
    end
  end
end
