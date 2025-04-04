# frozen_string_literal: true

module Components
  class ThreadItem < Components::Base
    prop :thread, DirectMessageThread, reader: :private

    def view_template
      link_to direct_message_thread_path(thread), class: 'block bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg p-4 transition-colors' do
        div(class: 'flex items-center gap-4') do
          # Get the other participants (everyone except current user)
          other_participants = thread.other_participants(Current.user)

          if other_participants.any?
            Components::Avatar(user: other_participants.first, size: :medium)

            div(class: 'flex-1') do
              h3(class: 'font-medium text-white') { thread.display_title(Current.user) }

              p(class: 'text-sm text-white/70 truncate') do
                if thread.last_message
                  "#{thread.last_message.user.username}: #{thread.last_message.content}"
                else
                  'Start a conversation'
                end
              end
            end

            # Show timestamp of last message
            if thread.last_message
              span(class: 'text-xs text-white/50') do
                if thread.last_message.created_at.today?
                  thread.last_message.created_at.strftime('%H:%M')
                else
                  thread.last_message.created_at.strftime('%b %d')
                end
              end
            end
          end
        end
      end
    end
  end
end
