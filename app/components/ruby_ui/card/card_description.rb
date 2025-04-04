# frozen_string_literal: true

module RubyUI
  class CardDescription < Base
    def view_template(&)
      p(**attrs, &)
    end

    private

    def default_attrs
      {
        class: 'text-sm text-white/60',
      }
    end
  end
end
