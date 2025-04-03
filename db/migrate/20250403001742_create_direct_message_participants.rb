class CreateDirectMessageParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :direct_message_participants do |t|
      t.references :direct_message_thread, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
