class AddLiabilityFieldsToCustomerLeads < ActiveRecord::Migration
  def change
    add_column :customer_leads, :business_id,  :integer, null: false
    add_column :customer_leads, :phone_number, :string
    add_column :customer_leads, :join_list,    :boolean, default: false
    add_column :customer_leads, :photo_uid,    :string
  end
end
