# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    protected

    def render_component_to_string(component)
      ApplicationController.render(component)
    end
  end
end
