class CreateUtransactions < ActiveRecord::Migration
  
  def up
    create_table :utransactions do |t|
      t.integer   :quantity,                default: 0
      t.integer   :user_id
      t.integer   :contract_id
      t.decimal   :contract_current_value,  precision: 15,    scale: 8,     :default => 0.00
      t.decimal   :contract_new_value,      precision: 15,    scale: 8,     :default => 0.00
      t.decimal   :cost,                    precision: 15,    scale: 8,     :default => 0.00
      t.string    :transaction_type,        limit: 1,         null: false

      t.timestamps
    end
    add_index :utransactions, [:user_id, :contract_id]
  end

  def down
    drop_table :utransactions
  end
end
