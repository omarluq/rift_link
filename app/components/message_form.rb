# frozen_string_literal: true

module Components
  class MessageForm < Components::Base
    prop :messageable, Object, reader: :private

    def view_template
      div(class: 'border-t border-white/10 p-4', id: 'new_message_form') do
        # Add typing indicator
        div(id: 'typing-indicator', class: 'text-xs text-cyan-300 mb-2 hidden', data: { chat_target: 'typingIndicator' })

        form_with(
          model: Message.new,
          url: form_url,
          class: 'flex gap-2',
          data: {
            controller: 'reset-form',
            action: 'turbo:submit-end->reset-form#reset',
          }
        ) do |form|
          form.text_field :content,
            class: 'flex-1 bg-white/5 border border-white/10 rounded-md px-4 py-2 text-white placeholder:text-white/50',
            placeholder: 'Type a message...',
            autocomplete: 'off',
            data: {
              action: 'input->chat#typing',
              chat_target: 'input',
            }

          form.submit 'Send',
            class: 'bg-cyan-500 hover:bg-cyan-600 text-white px-4 py-2 rounded-md transition-colors'
        end
      end
    end

    private

    def form_url
      case messageable
      when DirectMessageThread
        direct_message_thread_messages_path(messageable)
      else
        raise "Unsupported messageable type: #{messageable.class}"
      end
    end
  end
end
