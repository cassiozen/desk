class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :portal, index: true
      t.integer :requestor_id, index: true
      t.integer :assignee_id, index: true
      t.datetime :due_in
      t.hstore :properties

      t.timestamps
    end
  end
end
