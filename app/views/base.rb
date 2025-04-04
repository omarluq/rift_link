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

      turbo_frame_tag('sidenav', load: :lazy, src: sidenav_path, data: { turbo_permanent: true })
    end

    # Data fetching methods - now fetching from the database
    def page_title
      'RiftLink'
    end
  end
end
