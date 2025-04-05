# frozen_string_literal: true

module RubyUI
  class AlertDescription < Base
    def view_template(&)
      div(**attrs, &)
    end

    private

    def default_attrs
      {
        class: 'text-sm opacity-90',
      }
    end
  end
end
