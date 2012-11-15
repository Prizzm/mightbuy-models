class AddEmergencyPhonenumberToCustomerLeads < ActiveRecord::Migration
  def change
    add_column :customer_leads, :emergency_phone_number, :string
  end
end
