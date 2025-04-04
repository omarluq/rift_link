# frozen_string_literal: true

module Components
  class ThreadList < Components::Base
    prop :threads, ActiveRecord::Relation(DirectMessageThread), reader: :private

    def view_template
      div(class: 'space-y-4') do
        if threads.any?
          threads.each do |thread|
            Components::ThreadItem(thread:)
          end
        else
          div(class: 'bg-white/5 rounded-lg p-8 text-center') do
            p(class: 'text-white/70') { "You don't have any conversations yet." }
            link_to 'Find Friends', users_path, class: 'mt-4 inline-block bg-cyan-500 hover:bg-cyan-600 text-white px-4 py-2 rounded-md transition-colors'
          end
        end
      end
    end
  end
end
