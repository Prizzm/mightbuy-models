class AddPublicToBargins < ActiveRecord::Migration
  def change
    add_column :bargins, :public, :boolean
  end
end
