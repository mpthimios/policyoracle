class AddActivationToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :remember_digest, :string
  	add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end

  def self.down
    unless !(column_exists? :users, :remember_digest)
      remove_column :users, :remember_digest
    end
    unless !(column_exists? :users, :activation_digest)
      remove_column :users, :activation_digest
    end
    unless !(column_exists? :users, :activated)
      remove_column :users, :activated
    end
    unless !(column_exists? :users, :activated_at)
      remove_column :users, :activated_at
    end
  end

end
