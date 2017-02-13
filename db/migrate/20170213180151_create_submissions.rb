class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string      :submission_id,  unique: true, null: false
      t.string      :problem_id,     null: false
      t.string      :problem_source, null: false
      t.string      :status,         null: false
      t.references  :user,           null: false
      t.datetime    :date,           null: false

      t.timestamps
    end

    add_index :submissions, :submission_id
    add_index :submissions, :problem_id
    add_index :submissions, :status
    add_index :submissions, :date
  end
end
