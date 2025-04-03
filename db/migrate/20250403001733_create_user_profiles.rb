class CreateUserProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username
      t.string :display_name
      t.string :avatar
      t.text :bio
      t.string :gaming_status

      t.timestamps
    end
  end
end
