# frozen_string_literal: true

module RubyUI
  class Alert < Base
    def initialize(variant: nil, dismissible: false, **attrs)
      @variant = variant
      @dismissible = dismissible
      super(**attrs) # must be called after variant is set
    end

    def view_template(&)
      div(**attrs) do
        div(class: 'flex items-start gap-3') do
          render_icon
          div(class: 'flex-1') { yield }
          render_dismiss_button if @dismissible
        end
      end
    end

    private

    def render_icon
      case @variant
      when :success
        Lucide::CircleCheck class: 'h-5 w-5 text-green-400'
      when :warning
        Lucide::CircleAlert class: 'h-5 w-5 text-amber-400'
      when :destructive
        Lucide::TriangleAlert class: 'h-5 w-5 text-red-400'
      when :info
        Lucide::Info class: 'h-5 w-5 text-blue-400'
      else
        Lucide::Bell class: 'h-5 w-5 text-cyan-400'
      end
    end

    def render_dismiss_button
      button(
        type: 'button',
        class: 'rounded-md text-white/70 hover:text-white',
        data: { action: 'notifications#dismiss' }
      ) do
        Lucide::X class: 'h-4 w-4'
      end
    end

    def colors
      case @variant
      when :success
        'bg-green-500/10 border border-green-500/30 text-green-100'
      when :warning
        'bg-amber-500/10 border border-amber-500/30 text-amber-100'
      when :destructive
        'bg-red-500/10 border border-red-500/30 text-red-100'
      when :info
        'bg-blue-500/10 border border-blue-500/30 text-blue-100'
      else
        'bg-cyan-500/10 border border-cyan-500/30 text-cyan-100'
      end
    end

    def default_attrs
      base_classes = 'p-4 mb-4 rounded-md backdrop-blur-sm'
      {
        class: [base_classes, colors],
        data: { notifications_target: 'alert' },
      }
    end
  end
end
