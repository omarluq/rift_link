# frozen_string_literal: true

module Views
  module Sessions
    class Index < Views::Base
      prop :notice, _Nilable(String)
      prop :session, ActionDispatch::Request::Session
      prop :sessions, ActiveRecord::Relation(Session)
      attr_accessor :notice, :session, :sessions

      def view_template
        div(class: 'min-h-screen bg-white dark:bg-zinc-900 py-12 px-4 sm:px-6 lg:px-8') do
          div(class: 'max-w-md mx-auto') do
            if notice
              p(class: 'mb-6 p-4 text-primary-foreground bg-primary/20 border border-primary/20 rounded-md') { notice }
            end

            h1(class: 'text-2xl font-bold text-zinc-900 dark:text-zinc-50 mb-6') { 'Devices & Sessions' }

            div(id: 'sessions', class: 'space-y-6') do
              sessions.each do |session|
                div(id: (dom_id session),
                  class: 'bg-white dark:bg-zinc-800 shadow-md rounded-lg p-6 border border-secondary/20') do
                  p(class: 'mb-2') do
                    span(class: 'font-medium text-zinc-700 dark:text-zinc-300') { 'User Agent: ' }
                    span(class: 'text-zinc-600 dark:text-zinc-400') { session.user_agent }
                  end

                  p(class: 'mb-2') do
                    span(class: 'font-medium text-zinc-700 dark:text-zinc-300') { 'IP Address: ' }
                    span(class: 'text-zinc-600 dark:text-zinc-400') { session.ip_address }
                  end

                  p(class: 'mb-4') do
                    span(class: 'font-medium text-zinc-700 dark:text-zinc-300') { 'Created at: ' }
                    span(class: 'text-zinc-600 dark:text-zinc-400') do
                      session.created_at.in_time_zone.strftime('%B %d, %Y %I:%M %p %Z')
                    end
                  end

                  button_to('Log out',
                    session,
                    method: :delete,
                    class: 'w-full flex justify-center py-2 px-4
                      border border-transparent rounded-md shadow-sm
                      text-sm font-medium text-white
                      bg-destructive hover:bg-destructive/90
                      focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-destructive
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
