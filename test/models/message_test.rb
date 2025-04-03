# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id               :bigint           not null, primary key
#  attachment_url   :string
#  content          :text
#  is_pinned        :boolean
#  messageable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  messageable_id   :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_messages_on_messageable  (messageable_type,messageable_id)
#  index_messages_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
