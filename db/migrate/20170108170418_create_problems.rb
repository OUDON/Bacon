class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.string :title,          null: false
      t.string :url,            null: false
      t.string :contest_source, null: false
      t.string :problem_id,     null: false

      t.timestamps
    end
  end
end
