class AddAskPhonenumberToLeadConfigs < ActiveRecord::Migration
  def up
    add_column :lead_configs, :ask_for_phonenumber, :boolean
  end
  
  def down
     remove_column :lead_configs, :ask_for_phonenumber
   end
end
