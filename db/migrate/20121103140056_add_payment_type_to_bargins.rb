class AddPaymentTypeToBargins < ActiveRecord::Migration
  def change
    add_column :bargins, :payment_type, :string, default: "MightBuy"
  end
end
