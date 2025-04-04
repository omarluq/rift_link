# frozen_string_literal: true

module Components
  class UserCard < Components::Base
    prop :user, User, reader: :private

    def view_template
      div(class: 'bg-white/5 border border-white/10 rounded-lg p-4 flex items-center justify-between') do
        div(class: 'flex items-center gap-4') do
          Components::Avatar(user:, size: :medium)

          div do
            h3(class: 'font-medium text-white') { user.username }
            p(class: 'text-sm text-white/70') { user.profile&.gaming_status || 'Offline' }
          end
        end

        div do
          Components::MessageButton(user:)
        end
      end
    end
  end
end
