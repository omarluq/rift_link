# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  action      :string
#  target_name :string
#  target_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  target_id   :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_activities_on_target   (target_type,target_id)
#  index_activities_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true

  validates :action, presence: true
  validates :target_name, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
