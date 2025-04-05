# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  description :text
#  end_time    :datetime
#  start_time  :datetime
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  realm_id    :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_events_on_realm_id  (realm_id)
#  index_events_on_user_id   (user_id)
#
# Foreign Keys
#
#  realm_id  (realm_id => realms.id)
#  user_id   (user_id => users.id)
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
