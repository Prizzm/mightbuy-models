class AddMessageToCustomerLeads < ActiveRecord::Migration
  def change
    add_column :customer_leads, :message, :text, default: ""
  end
end
