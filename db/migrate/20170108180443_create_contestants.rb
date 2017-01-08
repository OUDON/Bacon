class CreateContestants < ActiveRecord::Migration[5.0]
  def change
    create_table :contestants do |t|
      t.integer :contest_id, null: false
      t.integer :user_id,    null: false

      t.timestamps
    end

    add_index :contestants, :contest_id
    add_index :contestants, :user_id
    add_index :contestants, [:contest_id, :user_id], unique: true
  end
end
