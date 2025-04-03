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
          render_header
          main(class: 'container mx-auto pt-20') do
            # Main content from views
            yield
          end
        end
      end
    end

    def html_opt
      { class: 'h-full', data: { theme: :dark } }
    end

    private

    def render_header
      header(class: 'fixed w-full top-0 z-50') do
        # Frosted glass effect background
        div(class: 'absolute inset-0 bg-black/20 backdrop-blur-lg border-b border-white/10')

        # Header content
        div(class: 'relative container mx-auto px-4 sm:px-6 lg:px-8') do
          div(class: 'flex h-16 items-center justify-between') do
            # Logo
            div(class: 'flex-shrink-0') do
              link_to '/', class: 'flex items-center' do
                # Logo glow effect
                div(class: 'relative') do
                  div(class: 'absolute inset-0 bg-cyan-500/30 rounded-full blur-lg animate-pulse')
                  div(class: 'relative text-2xl font-bold tracking-wider flex items-center') do
                    span(class: 'text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-purple-500') { 'RIFT' }
                    span(class: 'text-white') { 'LINK' }
                  end
                end
              end
            end

            # Navigation - Desktop
            nav(class: 'hidden md:flex items-center space-x-6') do
              nav_link('Realms', '#')
              nav_link('Explore', '#')
              nav_link('Events', '#')
              nav_link('Friends', '#')
            end

            # Auth buttons/user menu
            div(class: 'flex items-center') do
              # Notifications
              button(class: 'relative p-2 mr-3 rounded-full hover:bg-white/10 transition-colors') do
                render Lucide::Bell class: 'h-5 w-5 text-indigo-300'
                # Notification badge
                div(class: 'absolute top-1 right-1 h-2 w-2 rounded-full bg-red-500')
              end

              # Messages
              button(class: 'relative p-2 mr-3 rounded-full hover:bg-white/10 transition-colors') do
                render Lucide::MessageSquare class: 'h-5 w-5 text-indigo-300'
              end

              # User dropdown or sign-in
              if defined?(Current.user) && Current.user
                # User avatar/menu
                div(class: 'relative') do
                  button(class: 'flex items-center space-x-3 px-3 py-2 rounded-lg bg-white/5 hover:bg-white/10 border border-white/10 transition-colors') do
                    div(class: 'w-8 h-8 rounded-full bg-gradient-to-br from-cyan-500 to-purple-600 flex items-center justify-center overflow-hidden') do
                      span { Current.user.username.first.upcase }
                    end
                    span(class: 'text-sm font-medium hidden sm:inline-block') { Current.user.username }
                    render Lucide::ChevronDown class: 'h-4 w-4 text-indigo-300 ml-1'
                  end
                  # Dropdown menu would go here
                end
              else
                # Sign in/up buttons
                div(class: 'flex items-center space-x-3') do
                  link_to 'Sign in', sign_in_path,
                    class: 'text-sm font-medium px-4 py-2 rounded-lg text-white hover:bg-white/10 border border-white/10 transition-colors'

                  link_to 'Sign up', sign_up_path,
                    class: 'text-sm font-medium px-4 py-2 rounded-lg text-white bg-gradient-to-r from-cyan-500 to-purple-600 hover:from-cyan-400 hover:to-purple-500 transition-colors shadow-lg shadow-cyan-500/20 hover:shadow-cyan-500/30'
                end
              end

              # Mobile menu button (only shown on mobile)
              button(class: 'ml-4 md:hidden p-2 rounded-md hover:bg-white/10 transition-colors') do
                render Lucide::Menu class: 'h-6 w-6 text-white'
              end
            end
          end
        end
      end
    end

    def nav_link(text, href)
      link_to href, class: 'relative text-sm font-medium text-indigo-100 hover:text-white transition-colors group' do
        span { text }
        # Animated underline on hover
        div(class: 'absolute bottom-0 left-0 h-[2px] w-0 bg-gradient-to-r from-cyan-400 to-purple-500 group-hover:w-full transition-all duration-300')
      end
    end

    def page_title
      'RiftLink'
    end
  end
end
