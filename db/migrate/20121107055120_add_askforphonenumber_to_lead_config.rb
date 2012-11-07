class AddAskforphonenumberToLeadConfig < ActiveRecord::Migration
  def change
    add_column :lead_configs, :ask_for_phonenumber, :boolean
  end
end
