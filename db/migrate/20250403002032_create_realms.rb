# frozen_string_literal: true

class CreateRealms < ActiveRecord::Migration[8.0]
  def change
    create_table :realms do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.string :banner
      t.references :user, null: false, foreign_key: true
      t.boolean :is_public

      t.timestamps
    end
  end
end
