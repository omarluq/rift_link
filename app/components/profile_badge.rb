# frozen_string_literal: true

module Components
  class ProfileBadge < Components::Base
    prop :user, User, reader: :private
    prop :status, String, default: -> { 'online' }, reader: :private

    def view_template
      div(class: 'p-4 border-b border-white/10') do
        div(class: 'flex items-center space-x-3') do
          render_avatar
          render_user_info
          render_status_menu
        end
      end
    end

    private

    def render_avatar
      Components::Avatar(
        user:,
        size: :medium,
        bg_class: 'bg-gradient-to-br from-cyan-500 to-purple-600'
      )
    end

    def render_user_info
      div(class: 'flex-1 min-w-0') do
        h3(class: 'text-sm font-medium text-white truncate') { user.username }
        div(class: 'flex items-center') do
          Components::StatusIndicator(status:)
          p(class: 'text-xs text-green-400') { status.capitalize }
        end
      end
    end

    def render_status_menu
      button(class: 'p-1 rounded-md hover:bg-white/10') do
        Lucide::ChevronDown class: 'h-4 w-4 text-white/70'
      end
    end
  end
end
