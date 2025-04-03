# frozen_string_literal: true

module Views
  module Home
    class Index < Views::Base
      prop :activities, ActiveRecord::Relation(Activity), default: -> { nil }, reader: :private

      def view_template
        div(class: 'container mx-auto p-6') do
          div(class: 'flex flex-row items-center mb-6') do
            Components::Logo()
          end

          Components::RealmsGrid(realms:)

          Components::ActivityFeed(
            activities:,
            title: 'Recent Activity',
            view_all_href: '#activities'
          )
        end
      end

      def page_title
        'RiftLink Home'
      end
    end
  end
end
