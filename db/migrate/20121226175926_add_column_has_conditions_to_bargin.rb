class AddColumnHasConditionsToBargin < ActiveRecord::Migration
  def change
    change_table :bargins do |t|
      t.boolean :has_conditions
    end
  end
end
