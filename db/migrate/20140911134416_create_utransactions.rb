class CreateUtransactions < ActiveRecord::Migration
  def change
    create_table :utransactions do |t|
      t.decimal :quantity, :default => 0
      t.integer :user_id
      t.integer :contract_id
      t.float :value, :default => 0
      t.float :contract_current_value, :default => 0
      t.float :contract_new_value, :default => 0
      t.string  :transaction_type, :limit => 1, :null => false

      t.timestamps
    end
    add_index :utransactions, [:user_id, :contract_id]
  end
end
