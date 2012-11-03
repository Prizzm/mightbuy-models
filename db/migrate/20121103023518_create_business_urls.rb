class CreateBusinessUrls < ActiveRecord::Migration
  def change
    create_table :business_urls do |t|
      t.string :domain
      t.integer :business_id
      t.timestamps
    end
  end
end
