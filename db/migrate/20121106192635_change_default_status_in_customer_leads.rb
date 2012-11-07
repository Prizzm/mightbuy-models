class ChangeDefaultStatusInCustomerLeads < ActiveRecord::Migration
  def up
    change_column_default :customer_leads, :status, "notsent"
  end

  def down
  end
end
