class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.integer :user_id
      t.integer :contract_id
      t.float :quantity, :default => 0
      t.float :price_purchased, :default => 0

      t.timestamps
    end
    add_index :holdings, [:user_id, :contract_id]
  end
end
