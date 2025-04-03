class CreateChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :channels do |t|
      t.references :realm, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :channel_type
      t.boolean :is_private

      t.timestamps
    end
  end
end
