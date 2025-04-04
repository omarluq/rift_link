# frozen_string_literal: true

module Components
  class Sidenav < Components::Base
    EMPTY_ARRAY = [].freeze

    prop :user, User, reader: :private
    prop :sections, Array, default: -> { [] }, reader: :private
    prop :control_items, Array, default: EMPTY_ARRAY, reader: :private

    def view_template
      div(class: 'w-64 h-full flex flex-col bg-zinc-800/50 border-r border-white/10 backdrop-blur-sm transition-all duration-300', data: { controller: 'sidenav', sidenav_target: 'panel' }) do
        # Top Profile Section
        render_profile_section

        # Navigation Sections
        div(class: 'flex-1 overflow-y-auto px-2 py-4') do
          sections.each do |section|
            Components::NavSection(title: section[:title]) do
              section[:items].each do |item|
                Components::SidenavItem(text: item[:text], href: item[:href], form_method: item[:form_method]) do
                  render item[:icon_component].new(class: 'mr-3 h-5 w-5 text-indigo-300 group-hover:text-cyan-300 transition-colors')
                end
              end
            end
          end
        end

        # Bottom Control Section
        render_control_section

        # Collapse button
        # render_collapse_button
      end
    end

    private

    def render_profile_section
      link_to(root_path, data: { turbo_frame: '_top' }) do
        Components::ProfileBadge(user:)
      end
    end

    def render_control_section
      div(class: 'mt-auto px-2 py-4 border-t border-white/10') do
        control_items.each do |item|
          Components::SidenavItem(text: item[:text], href: item[:href], form_method: item[:form_method]) do
            render item[:icon_component].new(class: 'mr-3 h-5 w-5 text-indigo-300 group-hover:text-cyan-300 transition-colors')
          end
        end
      end
    end

    def render_collapse_button
      button(class: 'absolute top-1/2 -right-3 bg-cyan-500 rounded-full p-1 shadow-lg border border-cyan-400 transform', data: { action: 'click->sidenav#toggle' }) do
        Lucide::ChevronLeft class: 'h-4 w-4 text-white'
      end
    end
  end
end
