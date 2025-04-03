# frozen_string_literal: true

module Views
  module DirectMessageThreads
    class Show < Views::Base
      def view_template
        h1 { 'DirectMessageThreads::Show' }
        p { 'Find me in ' }
      end
    end
  end
end
