class AddInviteToken < ActiveRecord::Migration
  def up
    add_column :users, :invite_token, :string
  end

  def down
    remove_column :users, :invite_token
  end
end
