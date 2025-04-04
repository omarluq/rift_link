# frozen_string_literal: true

module Views
  module DirectMessageThreads
    class Index < Views::Base
      prop :threads, ActiveRecord::Relation(DirectMessageThread), reader: :private

      def view_template
        div(class: 'container mx-auto p-6') do
          h1(class: 'text-2xl font-semibold mb-6') { 'Direct Messages' }
          Components::ThreadList(threads:)
        end
      end
    end
  end
end
