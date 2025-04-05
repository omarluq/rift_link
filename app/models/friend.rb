# frozen_string_literal: true

# == Schema Information
#
# Table name: friends
#
#  id         :integer          not null, primary key
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_friends_on_friend_id  (friend_id)
#  index_friends_on_user_id    (user_id)
#
# Foreign Keys
#
#  friend_id  (friend_id => friends.id)
#  user_id    (user_id => users.id)
#
class Friend < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :status, inclusion: { in: ['pending', 'accepted', 'rejected', 'blocked'] }
  validates :friend_id, uniqueness: { scope: :user_id }
  validate :not_self_referential

  scope :accepted, -> { where(status: 'accepted') }
  scope :pending, -> { where(status: 'pending') }
  scope :incoming_requests, -> (user_id) { where(friend_id: user_id, status: 'pending') }
  scope :outgoing_requests, -> (user_id) { where(user_id:, status: 'pending') }

  private

  def not_self_referential
    if user_id == friend_id
      errors.add(:friend_id, "can't be the same as user")
    end
  end
end
