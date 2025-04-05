# frozen_string_literal: true

module Views
  module Settings
    class Index < Views::Base
      prop :user, User, reader: :private
      prop :user_profile, UserProfile, reader: :private
      prop :active_tab, String, reader: :private

      def view_template
        div(class: 'container mx-auto py-8 px-4 max-w-5xl') do
          div(class: 'mb-8 text-center') do
            h1(class: 'text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-cyan-300 to-purple-400') do
              'Settings'
            end
            p(class: 'text-white/60 mt-4') { 'Manage your profile, account, and preferences' }
          end

          # Main settings container
          div(class: 'bg-zinc-800/40 backdrop-blur-sm rounded-xl border border-white/10 overflow-hidden shadow-xl') do
            # RubyUI Tabs implementation
            render_rubyui_tabs
          end
        end
      end

      private

      def render_rubyui_tabs
        RubyUI::Tabs(default: active_tab) do
          # Tab List (Navigation)
          RubyUI::TabsList(class: 'w-full p-0 bg-zinc-800/60 border-b border-white/10') do
            tabs.each do |tab|
              RubyUI::TabsTrigger(
                value: tab[:id],
                class: 'data-[state=active]:border-b-2 data-[state=active]:border-cyan-400 data-[state=active]:bg-transparent data-[state=active]:text-cyan-300 data-[state=inactive]:text-white/70 rounded-none py-2.5 px-4',
              ) do
                render tab[:icon].new(class: 'h-4 w-4 mr-2 inline')
                span { tab[:name] }
              end
            end
          end

          # Tab Content
          tabs.each do |tab|
            RubyUI::TabsContent(value: tab[:id], class: 'p-6') do
              # Turbo Frame to lazy load the tab content
              turbo_frame_tag "settings-#{tab[:id]}-content",
                src: "/settings/#{tab[:id]}",
                loading: :lazy do
                render_loading_state
              end
            end
          end
        end
      end

      def render_loading_state
        div(class: 'flex justify-center items-center py-12') do
          div(class: 'animate-spin h-8 w-8 border-4 border-cyan-500 rounded-full border-t-transparent')
        end
      end

      def tabs
        [
          { id: 'profile', name: 'Profile', icon: Lucide::User },
          { id: 'account', name: 'Account', icon: Lucide::Shield },
          { id: 'sessions', name: 'Sessions', icon: Lucide::GlobeLock },
          { id: 'danger', name: 'Danger Zone', icon: Lucide::TriangleAlert },
        ]
      end
    end
  end
end
