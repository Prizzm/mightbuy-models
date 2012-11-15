class SetDefaultValuesToNoInLeadConfigs < ActiveRecord::Migration
  def up
    change_column_default :lead_configs, :ask_for_emergency_number,      false
  end

  def down
  end
end
