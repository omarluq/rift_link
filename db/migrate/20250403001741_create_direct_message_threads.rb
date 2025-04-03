# frozen_string_literal: true

class CreateDirectMessageThreads < ActiveRecord::Migration[8.0]
  def change
    create_table :direct_message_threads, &:timestamps
  end
end
