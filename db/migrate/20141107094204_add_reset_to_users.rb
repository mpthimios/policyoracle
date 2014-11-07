class AddResetToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_digest, :string
    add_column :users, :reset_sent_at, :datetime
  end

  def self.down
    unless !(column_exists? :users, :reset_digest)
      remove_column :users, :reset_digest
    end
    unless !(column_exists? :users, :reset_sent_at)
      remove_column :users, :reset_sent_at
    end
  end
end
