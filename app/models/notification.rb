# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  notification_type :string
#  read              :boolean
#  source_type       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_id         :string
#  user_id           :bigint           not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user

  NOTIFICATION_TYPES = [
    'friend_request',
    'friend_accepted',
    'realm_invite',
    'message_mention',
    'event_invite',
    'event_reminder',
  ].freeze

  validates :notification_type, inclusion: { in: NOTIFICATION_TYPES }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(15) }

  before_validation :set_default_read_status, on: :create

  def mark_as_read
    update(read: true)
  end

  private

  def set_default_read_status
    self.read = false if read.nil?
  end
end
