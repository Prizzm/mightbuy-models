class SetDefaultValuesToNoInLeadConfigs < ActiveRecord::Migration
  def up
    change_column_default :lead_configs, :include_liability,      false
    change_column_default :lead_configs, :ask_for_name,           false
    change_column_default :lead_configs, :ask_to_join_list,       false
    change_column_default :lead_configs, :include_product_select, false
    change_column_default :lead_configs, :ask_for_phonenumber,    false
  end

  def down
  end
end
