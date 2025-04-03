# frozen_string_literal: true

module Components
  class StatusIndicator < Components::Base
    prop :status, String, default: -> { 'online' }, reader: :private

    def view_template
      div(class: "h-2 w-2 rounded-full #{status_color} mr-2")
    end

    private

    def status_color
      case status.to_s.downcase
      when 'online'
        'bg-green-500'
      when 'idle', 'away'
        'bg-yellow-500'
      when 'busy', 'do_not_disturb'
        'bg-red-500'
      when 'offline'
        'bg-gray-500'
      else
        'bg-gray-500'
      end
    end
  end
end
