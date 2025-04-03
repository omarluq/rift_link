# frozen_string_literal: true

module Components
  class ActionButton < Components::Base
    EMPTY_HASH = {}.freeze

    prop :text, String, reader: :private
    prop :href, _Nilable(String), default: nil, reader: :private
    prop :variant, Symbol, default: :primary, reader: :private
    prop :size, Symbol, default: :medium, reader: :private
    prop :method, _Nilable(Symbol), default: nil, reader: :private
    prop :data, Hash, default: EMPTY_HASH, reader: :private

    def view_template(&block)
      if href.present?
        if method.present?
          button_to(href, method:, class: button_classes, data:) do
            yield if block_given?
            span { text }
          end
        else
          link_to(href, class: button_classes, data:) do
            yield if block_given?
            span { text }
          end
        end
      else
        button(type: 'button', class: button_classes, data:) do
          yield if block_given?
          span { text }
        end
      end
    end

    private

    def button_classes
      base_classes = []

      # Size classes
      size_classes = case size
                     when :small
                       'px-3 py-1 text-xs rounded-full'
                     when :medium
                       'px-4 py-2 text-sm rounded-md'
                     when :large
                       'px-5 py-3 text-base rounded-md'
                     else
                       'px-4 py-2 text-sm rounded-md'
      end

      # Variant classes
      variant_classes = case variant
                        when :primary
                          'bg-gradient-to-r from-cyan-500 to-purple-600 hover:from-cyan-400 hover:to-purple-500 text-white shadow-lg shadow-cyan-500/20'
                        when :secondary
                          'bg-cyan-500/20 text-cyan-300 hover:bg-cyan-500/30'
                        when :outline
                          'border border-white/20 text-white hover:bg-white/10'
                        when :ghost
                          'text-white hover:bg-white/10'
                        when :destructive
                          'bg-red-500/20 text-red-300 hover:bg-red-500/30'
                        else
                          'bg-cyan-500/20 text-cyan-300 hover:bg-cyan-500/30'
      end

      # Common classes
      common_classes = 'font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-cyan-400/50 focus:ring-offset-zinc-900'

      # Combine all classes
      base_classes.concat([size_classes, variant_classes, common_classes]).join(' ')
    end
  end
end
