# frozen_string_literal: true

module Components
  class NavSection < Components::Base
    prop :title, String, reader: :private

    def view_template(&block)
      div(class: 'mb-4') do
        h3(class: 'px-4 mb-2 text-xs font-semibold text-cyan-300 uppercase tracking-wider') { title }
        div(class: 'space-y-1') do
          yield if block_given?
        end
      end
    end
  end
end
