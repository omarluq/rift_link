# frozen_string_literal: true

# == Schema Information
#
# Table name: direct_message_participants
#
#  id                       :integer          not null, primary key
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
#  direct_message_thread_id  (direct_message_thread_id => direct_message_threads.id)
#  user_id                   (user_id => users.id)
#
class DirectMessageParticipant < ApplicationRecord
  belongs_to :direct_message_thread
  belongs_to :user

  validates :user_id, uniqueness: { scope: :direct_message_thread_id }
end
