# frozen_string_literal: true

module Components
  extend Phlex::Kit
  class Base < Phlex::HTML
    include Components
    include RubyUI
    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ButtonTo
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::ContentFor
    include Phlex::Rails::Helpers::Tag
    include Phlex::Rails::Helpers::CSPMetaTag
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::EmailField
    include Phlex::Rails::Helpers::PasswordField
    include Phlex::Rails::Helpers::HiddenField
    include Phlex::Rails::Helpers::Notice
    include Phlex::Rails::Helpers::Pluralize
    include Phlex::Rails::Helpers::DOMID
    include Phlex::Rails::Helpers::TurboStreamFrom
    include Phlex::Rails::Helpers::TurboFrameTag
    include Phlex::Rails::Helpers::ActionCableMetaTag
    include Phlex::Rails::Helpers::OptionsForSelect
    include Phlex::Rails::Helpers::TimeAgoInWords
    include Phlex::Rails::Helpers::ImageTag
    include PhlexIcons
    extend Literal::Properties

    # Include any helpers you want to be available across all components
    include Phlex::Rails::Helpers::Routes

    if Rails.env.development?
      def before_template
        comment { "Before #{self.class.name}" }
        super
      end
    end
  end
end
