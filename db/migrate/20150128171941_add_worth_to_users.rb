class AddWorthToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :worth, :decimal,  precision: 15,    scale: 4,     :default => 0.00
    add_column :users, :worth_updated_at, :datetime
  end
  def self.down
    unless !(column_exists? :users, :worth)
      remove_column :users, :worth
    end
    unless !(column_exists? :users, :worth_updated_at)
      remove_column :users, :worth_updated_at
    end
  end
end
