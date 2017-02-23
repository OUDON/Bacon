class ChangeDefaultValueToContests < ActiveRecord::Migration[5.0]
  def change
    change_column_default :contests, :penalty_time, 5
    change_column :contests, :standings, :text, default: [].to_yaml
  end
end
