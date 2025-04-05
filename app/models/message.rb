# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id               :integer          not null, primary key
#  attachment_url   :string
#  content          :text
#  is_pinned        :boolean
#  messageable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  messageable_id   :integer          not null
#  user_id          :integer          not null
#
# Indexes
#
#  index_messages_on_messageable  (messageable_type,messageable_id)
#  index_messages_on_user_id      (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :messageable, polymorphic: true

  validates :content, presence: true, unless: -> { attachment_url.present? }

  scope :recent, -> { order(created_at: :desc) }

  # Check if the message can be edited by a user
  def editable_by?(user)
    return false unless user
    user_id == user.id ||
      (messageable.respond_to?(:realm) &&
       messageable.realm.memberships.exists?(user:, member_role: ['admin', 'moderator']))
  end

  # Check if the message can be deleted by a user
  def deletable_by?(user)
    return false unless user
    user_id == user.id ||
      (messageable.respond_to?(:realm) &&
       messageable.realm.memberships.exists?(user:, member_role: ['admin', 'moderator']))
  end
end
