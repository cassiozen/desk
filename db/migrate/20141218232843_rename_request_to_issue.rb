class RenameRequestToIssue < ActiveRecord::Migration
  def change
    rename_column :interactions, :request_id, :issue_id
    rename_column :request_states, :request_id, :issue_id
    rename_table :request_states, :issue_states
    rename_table :requests, :issues
  end
end
