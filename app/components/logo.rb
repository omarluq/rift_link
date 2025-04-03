# frozen_string_literal: true

module Components
  class Logo < Components::Base
    def view_template
      div class: 'flex items-center' do
        # Logo glow effect
        div(class: 'relative') do
          div(class: 'absolute inset-0 bg-cyan-500/30 rounded-full blur-lg animate-pulse')
          div(class: 'relative text-2xl font-bold tracking-wider flex items-center') do
            span(class: 'text-transparent text-grd') { 'RIFT' }
            span(class: 'text-white') { 'LINK' }
          end
        end
      end
    end
  end
end
