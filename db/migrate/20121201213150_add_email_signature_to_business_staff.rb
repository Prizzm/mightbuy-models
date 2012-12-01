class AddEmailSignatureToBusinessStaff < ActiveRecord::Migration
  def change
    add_column :business_staffs, :email_signature, :string
  end
end
