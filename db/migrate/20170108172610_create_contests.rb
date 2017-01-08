class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.string     :title,        null: false
      t.integer    :penalty_time, null: false, default: 0
      t.text       :standings,    null: false, default: ""
      t.references :problem

      t.timestamps
    end

    add_index :contests, [:title, :created_at]
  end
end