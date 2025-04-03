# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  description :text
#  end_time    :datetime
#  start_time  :datetime
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  realm_id    :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_events_on_realm_id  (realm_id)
#  index_events_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (realm_id => realms.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
