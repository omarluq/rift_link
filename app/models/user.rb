# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  has_one :profile, class_name: 'UserProfile', dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :messages, dependent: :nullify

  has_many :owned_realms, class_name: 'Realm', foreign_key: 'user_id', dependent: :destroy

  # Polymorphic memberships - realms, etc.
  has_many :realms, through: :memberships, source: :membershipable, source_type: 'Realm'

  # Direct messages
  has_many :direct_message_participants, dependent: :destroy
  has_many :direct_message_threads, through: :direct_message_participants

  # Events
  has_many :events, dependent: :destroy
  has_many :event_participants, dependent: :destroy
  has_many :attending_events, through: :event_participants, source: :event

  # Friends
  has_many :friendships, class_name: 'Friend', dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # Notifications
  has_many :notifications, dependent: :destroy

  delegate :username, :avatar, to: :profile

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def admin_of?(membershipable)
    memberships.exists?(membershipable:, member_role: 'admin')
  end

  def moderator_of?(membershipable)
    memberships.exists?(membershipable:, member_role: ['admin', 'moderator'])
  end

  def member_of?(membershipable)
    memberships.exists?(membershipable:)
  end
end
