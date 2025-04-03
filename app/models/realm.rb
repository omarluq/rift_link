# frozen_string_literal: true

# == Schema Information
#
# Table name: realms
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  icon        :string
#  banner      :string
#  user_id     :bigint           not null
#  is_public   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_realms_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Realm < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  has_many :channels, dependent: :destroy
  has_many :memberships, as: :membershipable, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :events, dependent: :destroy
  has_many :activities, as: :target, dependent: :destroy

  validates :name, presence: true

  # Check if a user is a member
  def member?(user)
    memberships.exists?(user:)
  end

  # Get role of a user
  def role_for(user)
    memberships.find_by(user:)&.member_role
  end

  # Get member count
  def member_count
    memberships.count
  end

  # Convenience method for views
  def joined?(user = Current.user)
    member?(user)
  end

  # Method for banner URL - in real app would use ActiveStorage
  def banner_url
    banner if banner.present?
  end
end
