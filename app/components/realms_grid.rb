# frozen_string_literal: true

module Components
  class RealmsGrid < Components::Base
    prop :realms, ActiveRecord::Relation(Realm), default: -> { [] }, reader: :private

    def view_template
      div(class: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8') do
        realms.each do |realm|
          Components::RealmCard(realm:)
        end
      end
    end
  end
end
