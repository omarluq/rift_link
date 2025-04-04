# frozen_string_literal: true

module Components
  class FlashNotification < Components::Base
    prop :type, Symbol, reader: :private
    prop :message, String, reader: :private

    def view_template
      div(class: "fixed top-4 right-4 p-4 rounded-md shadow-lg #{background_class} transition-all",
        data: { controller: 'notification', 'notification-target': 'notification' }) do
        div(class: 'flex items-center space-x-3') do
          render_icon
          p(class: 'text-sm font-medium') { message }

          button(type: 'button', class: 'ml-auto text-white/70 hover:text-white',
            data: { action: 'notification#close' }) do
            Lucide::X class: 'h-4 w-4'
          end
        end
      end
    end

    private

    def background_class
      case type
      when :notice, :success
        'bg-green-500 text-white'
      when :alert, :error
        'bg-red-500 text-white'
      else
        'bg-cyan-500 text-white'
      end
    end

    def render_icon
      case type
      when :notice, :success
        Lucide::CircleCheck class: 'h-5 w-5'
      when :alert, :error
        Lucide::CircleAlert class: 'h-5 w-5'
      else
        Lucide::Bell class: 'h-5 w-5'
      end
    end
  end
end
