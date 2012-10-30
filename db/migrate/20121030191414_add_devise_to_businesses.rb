class AddDeviseToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :logo_uid, :string
    add_column :businesses, :email, :string
    add_column :businesses, :url, :string
    add_column :businesses, :phone, :string
    add_column :businesses, :facebook_url, :string
    add_column :businesses, :twitter_handle, :string
    add_column :businesses, :pinterest_handle, :string
    add_column :businesses, :address, :text
  end
end
