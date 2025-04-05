# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  message           :string           not null
#  notification_type :string
#  read              :boolean
#  source_type       :string
#  title             :string           not null
#  variant           :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_id         :string
#  user_id           :integer          not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
