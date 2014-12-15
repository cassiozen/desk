class CreateRequestorProfiles < ActiveRecord::Migration
  def change
    create_table :requestor_profiles do |t|

      t.timestamps
    end
  end
end
