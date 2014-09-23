class CreateHoldings < ActiveRecord::Migration
  
  def up
    create_table :holdings do |t|
      t.integer   :user_id
      t.integer   :contract_id
      t.integer   :quantity,          default: 0
      t.decimal   :price_purchased,   precision: 15,    scale: 8,   default: 0.00

      t.timestamps
    end
    add_index :holdings, [:user_id, :contract_id]
  end

  def down
    drop_table :holdings
  end
end
