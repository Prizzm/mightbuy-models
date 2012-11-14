class UpdateFqdnToExistingBusinesses < ActiveRecord::Migration
  def up
    BusinessUrl.reset_column_information

    BusinessUrl.all.each do |business_url|
      business_url.update_fqdn
      business_url.save!
    end
  end

  def down
  end
end
