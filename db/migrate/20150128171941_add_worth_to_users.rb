class AddWorthToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :worth, :float, default:  0
    add_column :users, :worth_updated_at, :datetime
  end
  def self.down
    unless !(column_exists? :users, :worth)
      remove_column :users, :worth
    end
    unless !(column_exists? :users, :worth)
      remove_column :users, :worth_updated_at
    end
  end
end
