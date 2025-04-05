# frozen_string_literal: true

module Components
  class Avatar < Components::Base
    prop :user, User, reader: :private
    prop :size, Symbol, default: :medium, reader: :private
    prop :bg_class, String, default: -> { 'bg-gradient-to-br from-indigo-500 to-purple-600' }, reader: :private

    def view_template
      div(class: "#{size_class} rounded-full #{bg_class} flex items-center justify-center overflow-hidden") do
        if user.avatar.attached?
          # Use ActiveStorage's image_tag helper
          image_tag url_for(user.avatar), alt: "#{display_name}'s avatar", class: 'w-full h-full object-cover'
        else
          span(class: "text-white #{font_class}") { initials }
        end
      end
    end

    private

    def size_class
      case size
      when :small
        'w-8 h-8'
      when :medium
        'w-10 h-10'
      when :large
        'w-12 h-12'
      else
        'w-10 h-10'
      end
    end

    def font_class
      case size
      when :small
        'text-xs font-bold'
      when :medium
        'text-sm font-bold'
      when :large
        'text-base font-bold'
      else
        'text-sm font-bold'
      end
    end

    def initials
      if user.respond_to?(:username) && user.username.present?
        user.username[0..1].upcase
      elsif user.respond_to?(:name) && user.name.present?
        user.name[0..1].upcase
      else
        '??'
      end
    end

    def display_name
      if user.respond_to?(:username) && user.username.present?
        user.username
      elsif user.respond_to?(:name) && user.name.present?
        user.name
      else
        'User'
      end
    end
  end
end
