# frozen_string_literal: true

module Views
  module Home
    class Sidenav < Components::Base
      prop :realms, _Nilable(ActiveRecord::Relation(Realm)), default: -> { nil }, reader: :private
      prop :my_realms, _Nilable(ActiveRecord::Relation(Realm)), default: -> { nil }, reader: :private
      prop :pinned_realms, _Nilable(ActiveRecord::Relation(Realm)), default: -> { nil }, reader: :private
      prop :direct_messages, _Nilable(ActiveRecord::Relation(DirectMessageThread)), default: -> { nil }, reader: :private

      def view_template
        turbo_frame_tag('sidenav') do
          Components::Sidenav(
            user: Current.user,
            sections: sidenav_sections,
            control_items: sidenav_control_items
          )
        end
      end

    private

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
            title: 'Messages',
            items: [
              # Link to all direct messages
              {
                text: 'All Messages',
                href: direct_message_threads_path,
                icon_component: Lucide::MessageCircleMore,
                form_method: nil,
              },
              # Then individual message threads
              *direct_messages.map { |thread|
                partner = thread.other_participant(Current.user)
                next unless partner&.profile
                {
                  text: partner.profile.username,
                  href: direct_message_thread_path(thread),
                  icon_component: Lucide::MessageCircle,
                  form_method: nil,
                }
              }.compact,
            ],
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
    end
  end
end
