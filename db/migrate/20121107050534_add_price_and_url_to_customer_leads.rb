class AddPriceAndUrlToCustomerLeads < ActiveRecord::Migration
  def change
    add_column :customer_leads, :price, :decimal, precision: 6, scale: 2
    add_column :customer_leads, :url,   :string
  end
end
