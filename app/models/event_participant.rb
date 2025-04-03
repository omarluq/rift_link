# frozen_string_literal: true

# == Schema Information
#
# Table name: event_participants
#
#  id         :bigint           not null, primary key
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_participants_on_event_id  (event_id)
#  index_event_participants_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
class EventParticipant < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :status, inclusion: { in: ['going', 'maybe', 'not_going'] }
  validates :user_id, uniqueness: { scope: :event_id }

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= 'going'
  end
end
