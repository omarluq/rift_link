# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  member_role       :string
#  nickname          :string
#  membershipable_type :string           not null
#  membershipable_id :bigint           not null
#  joined_at         :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_memberships_on_membershipable  (membershipable_type,membershipable_id)
#  index_memberships_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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
