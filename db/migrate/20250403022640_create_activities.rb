class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.string :target_name
      t.references :target, polymorphic: true, null: false

      t.timestamps
    end
  end
end
