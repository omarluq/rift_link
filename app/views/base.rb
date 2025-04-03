# frozen_string_literal: true

module Views
  class Base < Components::Base
    # The `Views::Base` is an abstract class for all your views.
    # By default, it inherits from `Components::Base`, but you
    # can change that to `Phlex::HTML` if you want to keep views and
    # components independent.
    register_output_helper :vite_javascript_tag
    register_output_helper :vite_stylesheet_tag
    register_output_helper :vite_client_tag
    register_output_helper :csrf_meta_tags
    register_output_helper :csp_meta_tags
    register_output_helper :action_cable_meta_tag

    prop :realms, _Nilable(ActiveRecord::Relation(Realm)), default: -> { nil }, reader: :private
    prop :my_realms, _Nilable(ActiveRecord::Relation(Realm)), default: -> { nil }, reader: :private
    prop :pinned_realms, _Nilable(ActiveRecord::Relation(Realm)), default: -> { nil }, reader: :private
    prop :direct_messages, _Nilable(ActiveRecord::Relation(DirectMessageThread)), default: -> { nil }, reader: :private

    def around_template
      doctype
      html(**html_opt) do
        head do
          title { page_title }
          meta(name: 'turbo-refresh-method', content: 'morph')
          meta(name: 'turbo-refresh-scroll', content: 'preserve')
          action_cable_meta_tag
          csrf_meta_tags
          csp_meta_tag
          content_for(:head)
          link(rel: 'icon', href: '/icon.png', type: 'image/png')
          link(rel: 'icon', href: '/icon.svg', type: 'image/svg+xml')
          link(rel: 'apple-touch-icon', href: '/icon.png')
          vite_stylesheet_tag('application', data: { 'turbo-track': 'reload' })
          vite_client_tag
          vite_javascript_tag('application')
        end
        body(class: 'bg-gradient-to-br from-zinc-900 via-indigo-950 to-purple-950 min-h-screen text-white') do
          whitespace
          # render_header
          # Main content from views
          div(class: 'flex h-screen overflow-hidden') do
            # Side Navigation using Component
            sidenav

            # Main content area
            main(class: 'flex-1 overflow-y-auto') do
              yield
            end
          end
        end
      end
    end

    def html_opt
      { class: 'h-full', data: { theme: :dark } }
    end

    private

    def sidenav
      return unless Current.user

      Components::Sidenav(
        user: Current.user,
        sections: sidenav_sections,
        control_items: sidenav_control_items
      )
    end

    def render_realms_section
      div(class: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8') do
        realms.each do |realm|
          Components::RealmCard(realm:)
        end
      end
    end

    def sidenav_sections
      [
        {
          title: 'Pinned Realms',
          items: pinned_realms.map { |realm|
            { text: realm.name, href: realm_path(realm), icon_component: Lucide::Star, form_method: nil }
          },
        },
        {
          title: 'My Realms',
          items: my_realms.map { |realm|
            { text: realm.name, href: realm_path(realm), icon_component: Lucide::Hash, form_method: nil }
          },
        },
        {
          title: 'Direct Messages',
          items: direct_messages.map { |thread|
            partner = thread.participants.reject { |p| p.user_id == Current.user.id }.first&.user
            next unless partner&.profile
            {
              text: partner.profile.username,
              href: direct_message_thread_path(thread),
              icon_component: Lucide::MessageSquare,
              form_method: nil,
            }
          }.compact,
        },
        {
          title: 'Explore',
          items: [
            { text: 'Discover Realms', href: explore_realms_path, icon_component: Lucide::Compass, form_method: nil },
            { text: 'Find Friends', href: users_path, icon_component: Lucide::Users, form_method: nil },
            { text: 'Popular Games', href: games_path, icon_component: Lucide::Gamepad2, form_method: nil },
          ],
        },
      ]
    end

    def sidenav_control_items
      [
        { text: 'Settings', href: settings_path, icon_component: Lucide::Settings, form_method: nil },
        {
          text: 'Sign Out',
          href: session_path(Current.session),
          form_method: :delete,
          icon_component: Lucide::LogOut,
        },
      ]
    end

    # Data fetching methods - now fetching from the database
    def page_title
      'RiftLink'
    end
  end
end
