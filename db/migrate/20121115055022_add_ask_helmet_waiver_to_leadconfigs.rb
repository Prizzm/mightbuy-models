class AddAskHelmetWaiverToLeadconfigs < ActiveRecord::Migration
  def change
    add_column :lead_configs, :ask_for_helmet_waiver, :boolean, :default => false
  end
end
