class UpdateUserIndexes < ActiveRecord::Migration
  def self.up
    remove_index :users, :email
    remove_index :users, :name

    add_index :users, [:email, :tenant_id]
    add_index :users, [:name, :tenant_id]
  end
  def self.down
    remove_index :users, [:email, :tenant_id]
    remove_index :users, [:name, :tenant_id]

    add_index :users, :email
    add_index :users, :name
  end
end
