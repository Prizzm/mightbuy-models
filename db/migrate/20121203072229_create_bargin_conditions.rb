class CreateBarginConditions < ActiveRecord::Migration
  def change
    create_table :bargin_conditions do |t|
      t.references :bargin
      t.string :object
      t.string :operator
      t.integer :operand

      t.timestamps
    end
    add_index :bargin_conditions, :bargin_id
  end
end
