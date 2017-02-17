class AddUserColorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name_color, :string, null: false, default: '#000000'
  end
end
