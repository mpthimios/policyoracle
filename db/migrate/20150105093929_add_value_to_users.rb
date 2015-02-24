class AddValueToUsers < ActiveRecord::Migration
  def up
	add_column 	:users, :value, :decimal,	precision: 15,    scale: 8,     default: 0.00
    add_index 	:users, [:tenant_id, :value]
  end

  def down
  	unless !(column_exists? :users, :value)
      remove_index :users, [:tenant_id, :value]
      remove_column :users, :value, :decimal
    end
  end

end
