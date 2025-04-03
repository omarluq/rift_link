# frozen_string_literal: true

# == Schema Information
#
# Table name: direct_message_participants
#
#  id                      :bigint           not null, primary key
#  direct_message_thread_id :bigint           not null
#  user_id                 :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_dm_participants_on_thread_id  (direct_message_thread_id)
#  index_dm_participants_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (direct_message_thread_id => direct_message_threads.id)
#  fk_rails_...  (user_id => users.id)
#
class DirectMessageParticipant < ApplicationRecord
  belongs_to :direct_message_thread
  belongs_to :user

  validates :user_id, uniqueness: { scope: :direct_message_thread_id }
end
