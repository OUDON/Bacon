class AddColumnAojIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :aoj_id, :string
  end
end
