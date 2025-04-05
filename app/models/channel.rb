# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id           :integer          not null, primary key
#  channel_type :string
#  description  :text
#  is_private   :boolean
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  realm_id     :bigint           not null
#
# Indexes
#
#  index_channels_on_realm_id  (realm_id)
#
# Foreign Keys
#
#  realm_id  (realm_id => realms.id)
#
class Channel < ApplicationRecord
  belongs_to :realm

  has_many :messages, as: :messageable, dependent: :destroy
  has_many :memberships, as: :membershipable, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  validates :name, presence: true
  validates :channel_type, inclusion: { in: ['text', 'voice', 'video'] }

  # By default, all members of a realm can access public channels
  def accessible_by?(user)
    !is_private? || memberships.exists?(user:) || realm.member?(user)
  end
end
