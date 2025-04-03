# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  action      :string
#  target_name :string
#  target_type :string           not null
#  target_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_activities_on_target  (target_type,target_id)
#  index_activities_on_user_id (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true

  validates :action, presence: true
  validates :target_name, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
