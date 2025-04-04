# frozen_string_literal: true

module Components
  class MessageItem < Components::Base
    prop :message, Message, reader: :private

    def view_template
      div(class: message_container_class, id: dom_id(message)) do
        div(class: 'flex items-start gap-4') do
          Components::Avatar(user: message.user, size: :small)

          div(class: 'flex flex-col') do
            div(class: 'flex items-baseline gap-2') do
              span(class: 'font-medium text-cyan-300') { message.user.username }
              span(class: 'text-xs text-white/50') { message.created_at.strftime('%H:%M') }
            end

            p(class: 'text-white break-words') { message.content }
          end
        end
      end
    end

    private

    def message_container_class
      base_class = 'message-container mb-4'
      if message.user == Current.user
        "#{base_class} ml-auto"
      else
        base_class
      end
    end
  end
end
