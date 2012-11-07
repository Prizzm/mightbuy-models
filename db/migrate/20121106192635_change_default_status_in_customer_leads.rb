class ChangeDefaultStatusInCustomerLeads < ActiveRecord::Migration
  def up
    change_column_default :customer_leads, :status, "Not Sent"
  end

  def down
  end
end
