# frozen_string_literal: true

module Views
  module Home
    class Index < Views::Base
      def view_template
        div(class: 'flex h-screen bg-zinc-900 text-white overflow-hidden') do
          # Side Navigation using Component
          Components::Sidenav(
            user: Current.user,
            sections: sidenav_sections,
            control_items: sidenav_control_items
          )

          # Main content area
          main(class: 'flex-1 overflow-y-auto') do
            div(class: 'container mx-auto p-6') do
              h1(class: 'text-3xl font-bold mb-6 text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-purple-500') do
                'Welcome to RiftLink'
              end

              render_realms_section

              Components::ActivityFeed(
                activities: fetch_activities,
                title: 'Recent Activity',
                view_all_href: '#activities'
              )
            end
          end
        end
      end

      def page_title
        'RiftLink Home'
      end

      private

      def render_realms_section
        div(class: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8') do
          fetch_realms.each do |realm|
            Components::RealmCard(realm:)
          end
        end
      end

      def sidenav_sections
        [
          {
            title: 'Pinned Realms',
            items: fetch_pinned_realms.map { |realm|
              { text: realm.name, href: realm_path(realm), icon_component: Lucide::Star, form_method: nil }
            },
          },
          {
            title: 'My Realms',
            items: fetch_my_realms.map { |realm|
              { text: realm.name, href: realm_path(realm), icon_component: Lucide::Hash, form_method: nil }
            },
          },
          {
            title: 'Direct Messages',
            items: fetch_direct_messages.map { |thread|
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
      def fetch_realms
        # Get featured realms (most active by membership count)
        Realm.left_joins(:memberships)
          .select('realms.*, COUNT(memberships.id) as member_count')
          .where(is_public: true)
          .group('realms.id')
          .order('member_count DESC')
          .limit(6)
      end

      def fetch_pinned_realms
        # Get realms that the user has pinned
        # For now we're just getting the two with the earliest membership
        Current.user.realms
          .joins(:memberships)
          .where(memberships: { user_id: Current.user.id })
          .order('memberships.joined_at ASC')
          .limit(2)
      end

      def fetch_my_realms
        # Get all realms the user is a member of excluding pinned realms
        pinned_ids = fetch_pinned_realms.pluck(:id)
        Current.user.realms
          .where.not(id: pinned_ids)
          .limit(5)
      end

      def fetch_direct_messages
        # Get user's direct message threads with most recent messages first
        DirectMessageThread.joins(:participants)
          .where(direct_message_participants: { user_id: Current.user.id })
          .joins('LEFT JOIN messages ON messages.messageable_type = \'DirectMessageThread\' AND messages.messageable_id = direct_message_threads.id')
          .select('direct_message_threads.*, MAX(messages.created_at) as last_message_at')
          .group('direct_message_threads.id')
          .order('last_message_at DESC NULLS LAST')
          .limit(3)
      end

      def fetch_activities
        # Get recent activities across the platform
        Activity.includes(:user)
          .order(created_at: :desc)
          .limit(5)
      end
    end
  end
end
