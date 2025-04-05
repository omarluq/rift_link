# frozen_string_literal: true

# == Schema Information
#
# Table name: friends
#
#  id         :integer          not null, primary key
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_friends_on_friend_id  (friend_id)
#  index_friends_on_user_id    (user_id)
#
# Foreign Keys
#
#  friend_id  (friend_id => friends.id)
#  user_id    (user_id => users.id)
#
require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
