class AddNameToBusinessStaff < ActiveRecord::Migration
  def change
    add_column :business_staffs, :name, :string
  end
end
