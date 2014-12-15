class CreateAssigneeProfiles < ActiveRecord::Migration
  def change
    create_table :assignee_profiles do |t|

      t.timestamps
    end
  end
end
