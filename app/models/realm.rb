# frozen_string_literal: true

# == Schema Information
#
# Table name: realms
#
#  id          :integer          not null, primary key
#  description :text
#  icon        :string
#  is_public   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_realms_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Realm < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  has_many :channels, dependent: :destroy
  has_many :memberships, as: :membershipable, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :events, dependent: :destroy
  has_many :activities, as: :target, dependent: :destroy

  validates :name, presence: true

  has_one_attached :banner

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
end
