class CreateUtransactions < ActiveRecord::Migration
  def change
    create_table :utransactions do |t|
      t.integer :quantity
      t.datetime :date
      t.integer :user_id
      t.integer :contract_id
      t.decimal :value
      t.decimal :contract_current_value
      t.decimal :contract_new_value

      t.timestamps
    end
    add_index :utransactions, [:user_id, :contract_id]
  end
end
