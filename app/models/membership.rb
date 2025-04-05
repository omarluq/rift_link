# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id                  :integer          not null, primary key
#  joined_at           :datetime
#  member_role         :string
#  membershipable_type :string           not null
#  nickname            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  membershipable_id   :integer          not null
#  user_id             :integer          not null
#
# Indexes
#
#  index_memberships_on_membershipable  (membershipable_type,membershipable_id)
#  index_memberships_on_user_id         (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :membershipable, polymorphic: true

  validates :member_role, inclusion: { in: ['admin', 'moderator', 'member'] }
  validates :user_id, uniqueness: { scope: [:membershipable_id, :membershipable_type] }

  before_validation :set_default_role, on: :create
  before_validation :set_joined_at, on: :create

  private

  def set_default_role
    self.member_role ||= 'member'
  end

  def set_joined_at
    self.joined_at ||= Time.current
  end
end
