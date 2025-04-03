# frozen_string_literal: true

class CreateFriends < ActiveRecord::Migration[8.0]
  def change
    create_table :friends do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
