class AddColumnToContest < ActiveRecord::Migration[5.0]
  def change
    add_column :contests, :start_at, :datetime
    add_column :contests, :end_at,   :datetime

    add_index  :contests, :start_at
    add_index  :contests, :end_at
  end
end
