# frozen_string_literal: true

module Components
  class ActivityFeed < Components::Base
    prop :activities, ActiveRecord::Relation(Activity), reader: :private
    prop :title, String, default: -> { 'Recent Activity' }, reader: :private
    prop :view_all_href, String, default: -> { '#' }, reader: :private

    def view_template
      div(class: 'bg-white/5 backdrop-blur-sm rounded-lg border border-white/10 overflow-hidden') do
        render_header
        render_activities
      end
    end

    private

    def render_header
      div(class: 'px-4 py-3 border-b border-white/10 flex items-center justify-between') do
        h3(class: 'font-medium text-white') { title }

        link_to view_all_href, class: 'text-xs text-cyan-300 hover:text-cyan-200 transition-colors' do
          'View All'
        end
      end
    end

    def render_activities
      if activities.any?
        div(class: 'divide-y divide-white/5') do
          activities.each do |activity|
            Components::ActivityItem(activity:)
          end
        end
      else
        div(class: 'px-4 py-8 text-center') do
          p(class: 'text-sm text-white/50') { 'No recent activity' }
        end
      end
    end
  end
end
