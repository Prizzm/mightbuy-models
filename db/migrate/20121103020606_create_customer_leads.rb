class CreateCustomerLeads < ActiveRecord::Migration
  def change
    create_table :customer_leads do |t|
      t.string :email
      t.string :name
      t.string :status
      t.integer :product_id
      t.timestamps
    end
  end
end
