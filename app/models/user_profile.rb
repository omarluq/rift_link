# frozen_string_literal: true

# == Schema Information
#
# Table name: user_profiles
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  username     :string
#  display_name :string
#  avatar       :string
#  bio          :text
#  gaming_status :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UserProfile < ApplicationRecord
  belongs_to :user

  validates :username, presence: true, uniqueness: true
  validates :gaming_status, inclusion: { in: ['online', 'away', 'busy', 'offline'] }, allow_nil: true

  def avatar_url
    # In a real app, this would be connected to ActiveStorage or similar
    # For now, return avatar field or nil to use the initials fallback
    avatar
  end
end
