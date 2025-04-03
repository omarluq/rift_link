class CreateDirectMessageThreads < ActiveRecord::Migration[8.0]
  def change
    create_table :direct_message_threads do |t|
      t.timestamps
    end
  end
end
