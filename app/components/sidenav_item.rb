# frozen_string_literal: true

module Components
  class SidenavItem < Components::Base
    prop :text, String, reader: :private
    prop :href, String, reader: :private
    prop :form_method, _Nilable(Symbol), default: nil, reader: :private

    def view_template(&block)
      if form_method
        button_to href, method: form_method, class: 'w-full group flex items-center px-4 py-2 text-sm font-medium rounded-md text-white hover:bg-white/10 transition-colors' do
          yield if block_given?
          span { text }
        end
      else
        link_to href, class: 'group flex items-center px-4 py-2 text-sm font-medium rounded-md text-white hover:bg-white/10 transition-colors' do
          yield if block_given?
          span { text }
        end
      end
    end
  end
end
