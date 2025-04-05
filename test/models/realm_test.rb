# frozen_string_literal: true

# == Schema Information
#
# Table name: realms
#
#  id          :integer          not null, primary key
#  description :text
#  icon        :string
#  is_public   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_realms_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'test_helper'

class RealmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
