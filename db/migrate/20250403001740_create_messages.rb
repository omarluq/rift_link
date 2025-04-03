# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.string :attachment_url
      t.boolean :is_pinned
      t.references :messageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
