# frozen_string_literal: true

class CreateGroupChats < ActiveRecord::Migration[8.0]
  def chande
    create_table :group_chats do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.string :icon

      t.timestamps
    end
  end
end
