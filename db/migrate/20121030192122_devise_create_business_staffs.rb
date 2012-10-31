class DeviseCreateBusinessStaffs < ActiveRecord::Migration
  def self.up
    create_table(:business_staffs) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable
      t.integer :business_id
      t.timestamps
    end

    add_index :business_staffs, :email,                :unique => true
    add_index :business_staffs, :reset_password_token, :unique => true
    # add_index :business_staffs, :confirmation_token,   :unique => true
    # add_index :business_staffs, :unlock_token,         :unique => true
    # add_index :business_staffs, :authentication_token, :unique => true
  end

  def self.down
    drop_table :business_staffs
  end
end
