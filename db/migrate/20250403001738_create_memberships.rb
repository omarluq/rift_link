class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.string :member_role
      t.string :nickname
      t.references :membershipable, polymorphic: true, null: false
      t.datetime :joined_at

      t.timestamps
    end
  end
end
