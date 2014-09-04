class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.integer :user_id
      t.integer :contract_id
      t.integer :quantity
      t.float :price_purchased

      t.timestamps
    end
    add_index :holdings, [:user_id, :contract_id]
  end
end
