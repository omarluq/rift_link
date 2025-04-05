# frozen_string_literal: true

# == Schema Information
#
# Table name: direct_message_threads
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DirectMessageThread < ApplicationRecord
  has_many :participants, class_name: 'DirectMessageParticipant', dependent: :destroy
  has_many :users, through: :participants
  has_many :messages, as: :messageable, dependent: :destroy

  # Check if a user is a participant
  def participant?(user)
    participants.exists?(user:)
  end

  # Get the other participant in a 1-on-1 conversation
  def other_participant(user)
    participants.where.not(user:).first&.user
  end

  # Get all participants except the given user
  def other_participants(user)
    users.where.not(id: user.id)
  end

  # Get the last message
  def last_message
    messages.order(created_at: :desc).first
  end

  # Get the title for display (uses usernames of participants)
  def display_title(current_user)
    others = other_participants(current_user).includes(:profile)
    if others.any?
      others.map { |u| u.profile&.username || 'Unknown User' }.join(', ')
    else
      'Empty Conversation'
    end
  end
end
