class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :rating, null: false, default: 0

      t.references :voteable, polymorphic: true

      t.references :user

      t.index([:voteable_type, :voteable_id, :user_id], unique: true)
    end
  end
end
