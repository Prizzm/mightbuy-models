class AddDiscountToBargins < ActiveRecord::Migration
  def change
    add_column :bargins, :discount, :decimal, precision: 6, scale: 2
  end
end
