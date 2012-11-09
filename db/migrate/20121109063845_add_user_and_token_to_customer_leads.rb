class AddUserAndTokenToCustomerLeads < ActiveRecord::Migration
  def change
    add_column :customer_leads, :invite_token, :string
    add_column :customer_leads, :user_id, :integer
  end
end
