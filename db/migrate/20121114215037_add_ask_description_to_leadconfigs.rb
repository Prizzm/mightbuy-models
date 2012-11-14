class AddAskDescriptionToLeadconfigs < ActiveRecord::Migration
  def change
    add_column :lead_configs, :ask_for_description, :boolean, :default => false
  end
end
