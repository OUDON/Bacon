class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.string :title,          null: false
      t.string :url,            null: false
      t.string :contest_source, null: false
      t.string :problem_id,     null: false
      t.integer :contest_id

      t.timestamps
    end

    add_index :problems, :contest_id
  end
end
