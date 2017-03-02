class ChangeColumnScreenNameToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :screen_name, :user_name
    change_column_null :users, :user_name, false
    add_index :users, :user_name, unique: true
  end
end
