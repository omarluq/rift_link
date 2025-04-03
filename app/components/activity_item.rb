# frozen_string_literal: true

module Components
  class ActivityItem < Components::Base
    prop :activity, Object, reader: :private

    def view_template
      div(class: 'px-4 py-3 hover:bg-white/5 transition-colors') do
        div(class: 'flex items-center') do
          render_avatar
          render_content
        end
      end
    end

    private

    def render_avatar
      Components::Avatar(
        user: activity.user,
        size: :small,
        bg_class: 'bg-gradient-to-br from-indigo-500 to-purple-600'
      )
    end

    def render_content
      div(class: 'flex-1 min-w-0 ml-3') do
        render_activity_text
        render_timestamp
      end
    end

    def render_activity_text
      p(class: 'text-sm text-white') do
        span(class: 'font-medium text-cyan-300 hover:underline') { activity.user.username }
        span { " #{activity.action} " }

        target_name = if activity.respond_to?(:target_name)
          activity.target_name
        elsif activity.respond_to?(:target) && activity.target.respond_to?(:name)
          activity.target.name
        else
          'unknown'
        end

        span(class: 'font-medium text-indigo-300 hover:underline') { target_name }
      end
    end

    def render_timestamp
      p(class: 'text-xs text-white/50') do
        if activity.respond_to?(:created_at)
          helpers.time_ago_in_words(activity.created_at) + ' ago'
        else
          'recently'
        end
      end
    end
  end
end
