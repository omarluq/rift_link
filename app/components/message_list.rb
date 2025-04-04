# frozen_string_literal: true

module Components
  class MessageList < Components::Base
    prop :messages, ActiveRecord::Relation(Message), reader: :private
    prop :thread, DirectMessageThread, reader: :private

    def view_template
      div(id: "thread_#{thread.id}_messages", class: 'flex-1 overflow-y-auto p-4 space-y-4', data: { controller: 'scroll' }) do
        messages.each do |message|
          Components::MessageItem(message:)
        end
      end
    end
  end
end
