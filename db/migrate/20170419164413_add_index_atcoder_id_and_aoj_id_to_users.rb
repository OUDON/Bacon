class AddIndexAtcoderIdAndAojIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :atcoder_id, unique: true
    add_index :users, :aoj_id, unique: true
  end
end
