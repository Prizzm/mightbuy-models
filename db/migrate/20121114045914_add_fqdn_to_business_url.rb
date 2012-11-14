class AddFqdnToBusinessUrl < ActiveRecord::Migration
  def change
    add_column :business_urls, :fqdn, :string
  end
end
