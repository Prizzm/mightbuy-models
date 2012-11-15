class AddAskemergencyphonenumberToLeadConfigs < ActiveRecord::Migration
  def change
    add_column :lead_configs, :ask_for_emergency_number, :boolean
  end
end
