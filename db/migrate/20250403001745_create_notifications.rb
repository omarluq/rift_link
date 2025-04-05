# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :source_type
      t.string :source_id
      t.string :notification_type
      t.string :variant, null: false
      t.string :title, null: false
      t.string :message, null: false
      t.boolean :read

      t.timestamps
    end
  end
end
