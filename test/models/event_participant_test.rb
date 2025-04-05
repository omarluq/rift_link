# frozen_string_literal: true

# == Schema Information
#
# Table name: event_participants
#
#  id         :integer          not null, primary key
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_event_participants_on_event_id  (event_id)
#  index_event_participants_on_user_id   (user_id)
#
# Foreign Keys
#
#  event_id  (event_id => events.id)
#  user_id   (user_id => users.id)
#
require 'test_helper'

class EventParticipantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
