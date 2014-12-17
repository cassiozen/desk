class CreateRequestStates < ActiveRecord::Migration
  def change
    create_table :request_states do |t|
      t.references :request, index: true
      t.string :state

      t.timestamps
    end
  end
end
