# == Schema Information
#
# Table name: user_profiles
#
#  id            :bigint           not null, primary key
#  avatar        :string
#  bio           :text
#  display_name  :string
#  gaming_status :string
#  username      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class UserProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
