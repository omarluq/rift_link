# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  realm_id    :bigint           not null
#  user_id     :bigint           not null
#  title       :string
#  description :text
#  start_time  :datetime
#  end_time    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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
class Event < ApplicationRecord
  belongs_to :realm
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  has_many :event_participants, dependent: :destroy
  has_many :participants, through: :event_participants, source: :user
  has_many :activities, as: :target, dependent: :destroy

  validates :title, presence: true
  validates :start_time, presence: true
  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }

  scope :upcoming, -> { where('start_time > ?', Time.current).order(start_time: :asc) }
  scope :past, -> { where('end_time < ?', Time.current).order(start_time: :desc) }
  scope :in_progress, -> { where('start_time < ? AND end_time > ?', Time.current, Time.current) }

  # Get participant count
  def participant_count
    event_participants.count
  end

  # Check if a user is a participant
  def participant?(user)
    event_participants.exists?(user:)
  end

  # Get participant status
  def status_for(user)
    event_participants.find_by(user:)&.status
  end

  private

  def end_time_after_start_time
    if end_time <= start_time
      errors.add(:end_time, 'must be after the start time')
    end
  end
end
