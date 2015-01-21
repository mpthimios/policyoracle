class AddMarketIdToHoldings < ActiveRecord::Migration
  def self.up
    add_column :holdings, :market_id, :integer
  end
  def self.down
    unless !(column_exists? :holdings, :market_id)
      remove_column :holdings, :market_id
    end
  end
end
