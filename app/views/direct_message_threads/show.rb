# frozen_string_literal: true

module Views
  module DirectMessageThreads
    class Show < Views::Base
      prop :thread, DirectMessageThread, reader: :private
      prop :messages, ActiveRecord::Relation(Message), reader: :private

      def view_template
        turbo_stream_from "user_#{Current.user.id}_messages"

        div(class: 'flex h-full flex-col', data: { controller: 'chat', chat_thread_id_value: thread.id }) do
          render_header
          Components::MessageList(messages:, thread:)
          Components::MessageForm(messageable: thread)
        end
      end

      private

      def render_header
        div(class: 'border-b border-white/10 p-4 flex items-center justify-between') do
          h1(class: 'text-xl font-semibold') do
            thread.display_title(Current.user)
          end

          # Online status indicator
          render_online_status
        end
      end

      def render_online_status
        other_user = thread.other_participant(Current.user)
        return unless other_user

        div(class: 'flex items-center') do
          if other_user.profile&.gaming_status == 'online'
            div(class: 'h-2 w-2 rounded-full bg-green-500 mr-2')
            span(class: 'text-sm text-white/70') { 'Online' }
          else
            div(class: 'h-2 w-2 rounded-full bg-gray-500 mr-2')
            span(class: 'text-sm text-white/70') { 'Offline' }
          end
        end
      end
    end
  end
end
