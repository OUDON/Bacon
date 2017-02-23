class CreateProblemSources < ActiveRecord::Migration[5.0]
  def change
    create_table :problem_sources do |t|
      t.string :problem_source,       null: false, unique: true
      t.string :latest_submission_id, null: false
      t.timestamps
    end
  end
end
