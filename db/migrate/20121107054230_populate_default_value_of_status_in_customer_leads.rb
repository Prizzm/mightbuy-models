class PopulateDefaultValueOfStatusInCustomerLeads < ActiveRecord::Migration
  def up
    CustomerLead.reset_column_information
    CustomerLead.all.each do |lead|
      lead.update_attributes(status: "notsent") unless lead.status
    end
  end

  def down
  end
end
