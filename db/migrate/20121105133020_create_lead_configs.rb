class CreateLeadConfigs < ActiveRecord::Migration
  def change
    create_table :lead_configs do |t|
      t.references  :business
      t.boolean  :include_liability, default: true
      t.text     :liability, default: ""
      t.boolean  :ask_for_name, default: true
      t.boolean  :ask_to_join_list, default: true
      t.boolean  :include_product_select, default: true

      t.timestamps
    end
  end
end
