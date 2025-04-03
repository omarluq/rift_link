# frozen_string_literal: true

module Components
  class RealmCard < Components::Base
    prop :realm, Object, reader: :private
    prop :header_class, String, default: -> { 'h-20 bg-gradient-to-r from-indigo-600 to-purple-600 relative' }, reader: :private

    def view_template
      div(class: 'bg-white/5 backdrop-blur-sm rounded-lg border border-white/10 overflow-hidden hover:border-cyan-500/50 transition-colors shadow-lg group') do
        render_header
        render_content
      end
    end

    private

    def render_header
      div(class: header_class) do
        div(class: 'absolute inset-0 opacity-20 bg-pattern-hex')

        if realm.respond_to?(:banner_url) && realm.banner_url.present?
          img(src: realm.banner_url, alt: "#{realm.name} banner", class: 'absolute inset-0 w-full h-full object-cover')
        end
      end
    end

    def render_content
      div(class: 'p-4') do
        render_card_header
        render_description
        render_footer
      end
    end

    def render_card_header
      div(class: 'flex items-start justify-between') do
        h3(class: 'text-lg font-semibold text-white group-hover:text-cyan-300 transition-colors') { realm.name }
        Components::CardMenu
      end
    end

    def render_description
      p(class: 'mt-1 text-sm text-white/70 line-clamp-2') { realm.description }
    end

    def render_footer
      div(class: 'mt-4 flex items-center justify-between') do
        render_member_count
        render_join_button
      end
    end

    def render_member_count
      div(class: 'flex items-center text-xs text-white/60') do
        Lucide::Users class: 'h-3.5 w-3.5 mr-1'
        span { "#{realm.member_count} members" }
      end
    end

    def render_join_button
      Components::ActionButton(
        text: joined? ? 'Leave' : 'Join',
        variant: :secondary,
        size: :small,
        href: '#'
      )
    end

    def joined?
      if realm.respond_to?(:joined?)
        realm.joined?
      elsif realm.respond_to?(:member?)
        realm.member?(Current.user)
      else
        false
      end
    end
  end
end
