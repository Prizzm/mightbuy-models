class AddDomainNameToProduct < ActiveRecord::Migration
  def change
    add_column :products, :domain_name, :string
  end
end
