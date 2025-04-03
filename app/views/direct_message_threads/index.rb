# frozen_string_literal: true

module Views
  module DirectMessageThreads
    class Index < Views::Base
      def view_template
        h1 { 'DirectMessageThreads::Index' }
        p { 'Find me in ' }
      end
    end
  end
end
