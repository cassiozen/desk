class AddTimestampAndIndexToMessages < ActiveRecord::Migration
  def change
    add_timestamps(:messages)
    add_index :messages, :created_at
  end
end
