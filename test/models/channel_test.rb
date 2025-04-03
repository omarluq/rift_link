# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id           :bigint           not null, primary key
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
#  fk_rails_...  (realm_id => realms.id)
#
require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
