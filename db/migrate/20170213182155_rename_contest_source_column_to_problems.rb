class RenameContestSourceColumnToProblems < ActiveRecord::Migration[5.0]
  def change
    rename_column :problems, :contest_source, :problem_source
  end
end
