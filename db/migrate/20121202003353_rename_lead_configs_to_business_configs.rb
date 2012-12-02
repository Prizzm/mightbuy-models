class RenameLeadConfigsToBusinessConfigs < ActiveRecord::Migration
  def change
    rename_table :lead_configs, :business_configs
  end
end
