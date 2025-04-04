# frozen_string_literal: true

module RubyUI
  class CardFooter < Base
    def view_template(&)
      div(**attrs, &)
    end

    private

    def default_attrs
      {
        class: 'flex items-center justify-between p-6 pt-0 border-t border-white/10 mt-6',
      }
    end
  end
end
