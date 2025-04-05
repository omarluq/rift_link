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
require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
