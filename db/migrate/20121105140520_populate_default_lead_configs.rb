class PopulateDefaultLeadConfigs < ActiveRecord::Migration
  def up
    LeadConfig.reset_column_information
    Business.all.each do |business|
      business.create_lead_config! unless business.lead_config
    end
  end

  def down
  end
end
