class UpdateUserIndexes < ActiveRecord::Migration
  def change
    remove_index :users, :email
    remove_index :users, :name

    add_index :users, [:email, :tenant_id]
    add_index :users, [:name, :tenant_id]
  end
end
