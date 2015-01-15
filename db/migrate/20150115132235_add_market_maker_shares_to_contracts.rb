class AddMarketMakerSharesToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :market_maker_shares, 		:integer, default:  0

  end
  def self.down
    remove_column :contracts, :market_maker_shares,		:integer

  end
end
