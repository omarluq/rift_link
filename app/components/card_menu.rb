# frozen_string_literal: true

module Components
  class CardMenu < Components::Base
    EMPTY_ARRAY = [].freeze

    prop :items, Array, default: EMPTY_ARRAY, reader: :private

    def view_template
      button(class: 'p-1.5 rounded-full hover:bg-white/10 transition-colors', data: { controller: 'dropdown' }) do
        Lucide::EllipsisVertical class: 'h-4 w-4 text-white/70'

        # Dropdown menu would be added here in a real implementation
        # Using data controller for dropdown functionality
      end
    end
  end
end
