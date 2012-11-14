class AddAskDescriptionToLeadconfigs < ActiveRecord::Migration
  def change
    add_column :leadconfigs, :ask_for_description, :boolean
  end
end
