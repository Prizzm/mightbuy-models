class AddInvitedFlag < ActiveRecord::Migration
  def up
    add_column :users, :newly_invited, :boolean
  end

  def down
    remove_column :users, :newly_invited
  end
end

