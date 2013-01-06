class RemoveProductIdFromCustomerLeads < ActiveRecord::Migration
  def up
    remove_column :customer_leads, :product_id
  end

  def down
    add_column :customer_leads, :product_id, :integer
  end
end
