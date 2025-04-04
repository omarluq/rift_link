# frozen_string_literal: true

module Components
  class SessionSettings < Components::Base
    prop :user, User, reader: :private

    def view_template
      turbo_frame_tag 'settings-sessions-content' do
        div(class: 'flex flex-row gap-2 align-center') do
          RubyUI::Heading(level: 2, class: 'mb-6 flex items-center') do
            Lucide::GlobeLock class: 'h-5 w-5 mr-2 text-cyan-400'
            'Active Sessions'
          end

          RubyUI::Text(as: 'p', class: 'mb-6 text-white/60') do
            'Manage your active login sessions across all your devices'
          end
        end
        render_sessions_list
      end
    end

    private

    def render_sessions_list
      if user.sessions.any?
        RubyUI::Card() do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Your devices' }
            RubyUI::CardDescription() { "You're currently logged in on these devices" }
          end

          RubyUI::CardContent() do
            div(class: 'space-y-4') do
              # Current session first
              current_session = user.sessions.find { |s| s == Current.session }
              render_session_card(current_session, true) if current_session

              # Then other sessions
              user.sessions.reject { |s| s == Current.session }.each do |session|
                render_session_card(session, false)
              end
            end
          end
        end
      else
        div(class: 'p-6 text-center bg-white/5 rounded-lg border border-white/10') do
          p(class: 'text-white/60') { 'No active sessions found.' }
        end
      end
    end

    def render_session_card(session, is_current)
      div(class: "p-4 rounded-lg mt-4 #{is_current ? 'bg-cyan-950/30 border border-cyan-500/20' : 'bg-white/5 border border-white/10'} flex items-start justify-between") do
        div(class: 'flex items-start space-x-3') do
          div(class: 'mt-1') do
            if is_current
              Lucide::Laptop class: 'h-6 w-6 text-cyan-400'
            else
              device_icon(session.user_agent)
            end
          end

          div(class: 'flex-1') do
            div(class: 'flex items-center') do
              if is_current
                div(class: 'h-2 w-2 rounded-full bg-green-500 mr-2')
                span(class: 'text-cyan-300 font-medium') { 'Current session' }
                div(class: 'ml-2 px-1.5 py-0.5 text-xs bg-cyan-500/20 text-cyan-300 rounded') { 'This device' }
              else
                div(class: 'h-2 w-2 rounded-full bg-white/50 mr-2')
                span(class: 'text-white/70') { device_name(session.user_agent) }
              end
            end

            p(class: 'text-xs text-white/50 mt-4 truncate max-w-md') { session.user_agent }

            div(class: 'mt-1 flex items-center text-xs text-white/50 space-x-2') do
              div(class: 'flex items-center') do
                Lucide::MapPin class: 'h-3 w-3 mr-1'
                span { session.ip_address }
              end
              div(class: 'w-1 h-1 bg-white/30 rounded-full')

              div(class: 'flex items-center') do
                Lucide::Clock class: 'h-3 w-3 mr-1'
                span { "Last active: #{time_ago_in_words(session.updated_at)} ago" }
              end

              if session_approximate_location(session.ip_address) != 'Unknown'
                div(class: 'w-1 h-1 bg-white/30 rounded-full')

                div(class: 'flex items-center') do
                  Lucide::Globe class: 'h-3 w-3 mr-1'
                  span { session_approximate_location(session.ip_address) }
                end
              end
            end
          end
        end

        unless is_current
          button_to session_path(session),
            method: :delete,
            form: { data: { turbo_confirm: 'Are you sure you want to end this session?' } },
            class: 'ml-4 flex items-center px-2 py-1 bg-red-500/20 hover:bg-red-500/30 text-red-300 text-xs rounded-md transition-colors' do
            Lucide::LogOut class: 'h-3 w-3 mr-1'
            'End session'
          end
        end
      end
    end

    def device_icon(user_agent)
      if user_agent.downcase.include?('iphone') || user_agent.downcase.include?('ipad')
        Lucide::Smartphone class: 'h-6 w-6 text-white/70'
      elsif user_agent.downcase.include?('android')
        Lucide::Smartphone class: 'h-6 w-6 text-white/70'
      elsif user_agent.downcase.include?('mobile')
        Lucide::Smartphone class: 'h-6 w-6 text-white/70'
      else
        Lucide::Monitor class: 'h-6 w-6 text-white/70'
      end
    end

    def device_name(user_agent)
      ua = user_agent.downcase

      if ua.include?('iphone')
        'iPhone'
      elsif ua.include?('ipad')
        'iPad'
      elsif ua.include?('android')
        if ua.include?('mobile')
          'Android phone'
        else
          'Android tablet'
        end
      elsif ua.include?('macintosh') || ua.include?('mac os')
        'Mac'
      elsif ua.include?('windows')
        'Windows PC'
      elsif ua.include?('linux')
        'Linux'
      elsif ua.include?('mobile')
        'Mobile device'
      else
        'Desktop'
      end
    end

    def session_approximate_location(ip)
      # In a real app, this would use GeoIP or similar
      # This is a placeholder that returns a random location for demo purposes

      if ip == '127.0.0.1' || ip.start_with?('192.168.')
        'Local network'
      elsif Current.session&.ip_address == ip
        'Current location'
      else
        ['Unknown', 'United States', 'Europe', 'Asia Pacific', 'Unknown'].sample
      end
    end

    def render_security_tips
      RubyUI::Button(variant: :ghost, size: :sm, class: 'text-cyan-300') do
        Lucide::Info class: 'h-4 w-4 mr-1'
        'Security tips'
      end
    end
  end
end
