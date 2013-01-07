class AddOtherToBargin < ActiveRecord::Migration
  def change
    add_column :bargins, :other, :string
  end
end
