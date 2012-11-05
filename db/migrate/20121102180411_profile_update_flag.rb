class ProfileUpdateFlag < ActiveRecord::Migration
  def up
    add_column :businesses, :profile_updated, :boolean
  end

  def down
    remove_column :businesses, :profile_updated
  end
end
