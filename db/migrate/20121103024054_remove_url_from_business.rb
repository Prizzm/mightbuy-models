class RemoveUrlFromBusiness < ActiveRecord::Migration
  def up
    remove_column :businesses, :url
  end

  def down
    add_column :businesses, :url, :string
  end
end
