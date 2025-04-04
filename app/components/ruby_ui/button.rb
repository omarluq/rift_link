# frozen_string_literal: true

module RubyUI
  class Button < Base
    def initialize(type: :button, variant: :primary, size: :md, icon: false, **attrs)
      @type = type
      @variant = variant.to_sym
      @size = size.to_sym
      @icon = icon
      super(**attrs)
    end

    def view_template(&)
      button(**attrs, &)
    end

    private

    def size_classes
      if @icon
        case @size
        when :sm then 'h-6 w-6'
        when :md then 'h-9 w-9'
        when :lg then 'h-10 w-10'
        when :xl then 'h-12 w-12'
        end
      else
        case @size
        when :sm then 'px-3 py-1.5 h-8 text-xs rounded-md'
        when :md then 'px-4 py-2 h-9 text-sm rounded-md'
        when :lg then 'px-4 py-2 h-10 text-base rounded-md'
        when :xl then 'px-6 py-3 h-12 text-base rounded-lg'
        end
      end
    end

    def primary_classes
      [
        'whitespace-nowrap inline-flex items-center justify-center font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:ring-offset-1 focus:ring-offset-zinc-900 disabled:opacity-50 disabled:pointer-events-none bg-gradient-to-r from-cyan-500 to-purple-600 hover:from-cyan-400 hover:to-purple-500 text-white shadow-lg shadow-cyan-500/20',
        size_classes,
      ]
    end

    def link_classes
      [
        'whitespace-nowrap inline-flex items-center justify-center font-medium transition-colors focus:outline-none text-cyan-300 hover:text-cyan-200 underline-offset-4 hover:underline disabled:opacity-50 disabled:pointer-events-none',
        size_classes,
      ]
    end

    def secondary_classes
      [
        'whitespace-nowrap inline-flex items-center justify-center font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:ring-offset-1 focus:ring-offset-zinc-900 disabled:opacity-50 disabled:pointer-events-none bg-cyan-500/20 text-cyan-300 hover:bg-cyan-500/30',
        size_classes,
      ]
    end

    def destructive_classes
      [
        'whitespace-nowrap inline-flex items-center justify-center font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-red-400/50 focus:ring-offset-1 focus:ring-offset-zinc-900 disabled:opacity-50 disabled:pointer-events-none bg-red-500/20 text-red-300 hover:bg-red-500/30',
        size_classes,
      ]
    end

    def outline_classes
      [
        'whitespace-nowrap inline-flex items-center justify-center font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:ring-offset-1 focus:ring-offset-zinc-900 disabled:opacity-50 disabled:pointer-events-none border border-white/20 text-white hover:bg-white/10',
        size_classes,
      ]
    end

    def ghost_classes
      [
        'whitespace-nowrap inline-flex items-center justify-center font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:ring-offset-1 focus:ring-offset-zinc-900 disabled:opacity-50 disabled:pointer-events-none text-white hover:bg-white/10',
        size_classes,
      ]
    end

    def default_classes
      case @variant
      when :primary then primary_classes
      when :link then link_classes
      when :secondary then secondary_classes
      when :destructive then destructive_classes
      when :outline then outline_classes
      when :ghost then ghost_classes
      end
    end

    def default_attrs
      {
        type: @type,
        class: default_classes,
      }
    end
  end
end
