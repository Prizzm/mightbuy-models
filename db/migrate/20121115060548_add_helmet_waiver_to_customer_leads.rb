class AddHelmetWaiverToCustomerLeads < ActiveRecord::Migration
  def change
    add_column :customer_leads, :helmet_waiver, :string
  end
end
