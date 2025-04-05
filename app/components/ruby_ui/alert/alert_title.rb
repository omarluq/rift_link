# frozen_string_literal: true

module RubyUI
  class AlertTitle < Base
    def view_template(&)
      h5(**attrs, &)
    end

    private

    def default_attrs
      {
        class: 'mb-1 font-medium text-base',
      }
    end
  end
end
