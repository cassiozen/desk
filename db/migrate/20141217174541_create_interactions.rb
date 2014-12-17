class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.references :request, index: true
      t.references :user, index: true
      t.integer :interacteable_id, index: true
      t.string :interacteable_type, index: true
      t.timestamps
    end
  end
end
