class AddJoinListDescriptionToLeadconfigs < ActiveRecord::Migration
  def change
    add_column :lead_configs, :join_list_description, :string
  end
end
