class RemoveUrlFromCustomerLeads < ActiveRecord::Migration
  def up
    remove_column :customer_leads, :url
    remove_column :users, :invite_token
    remove_column :users, :newly_invited
  end

  def down
    add_column :customer_leads, :url, :string
    add_column :users, :invite_token, :string
    add_column :users, :newly_invited, :boolean
  end
end
