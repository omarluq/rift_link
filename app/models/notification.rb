# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  message           :string           not null
#  notification_type :string
#  read              :boolean
#  source_type       :string
#  title             :string           not null
#  variant           :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_id         :string
#  user_id           :integer          not null
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
    'misc',
  ].freeze

  validates :notification_type, inclusion: { in: NOTIFICATION_TYPES }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(15) }

  before_validation :set_default_read_status, on: :create

  after_create_commit -> {
    broadcast_append_to(
      "user_#{user.id}_notifications",
      target: 'notifications',
      html: ApplicationController.render(
        Views::Notifications::Notification.new(notification: self)
      )
    )
  }

  def mark_as_read
    update(read: true)
  end

  private

  def set_default_read_status
    self.read = false if read.nil?
  end
end
