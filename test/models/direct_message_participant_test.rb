# frozen_string_literal: true

# == Schema Information
#
# Table name: direct_message_participants
#
#  id                       :bigint           not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  direct_message_thread_id :bigint           not null
#  user_id                  :bigint           not null
#
# Indexes
#
#  index_direct_message_participants_on_direct_message_thread_id  (direct_message_thread_id)
#  index_direct_message_participants_on_user_id                   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (direct_message_thread_id => direct_message_threads.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class DirectMessageParticipantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
