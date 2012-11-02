class AddUrlVerifiedFlagToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :url_verified, :boolean
  end
end
