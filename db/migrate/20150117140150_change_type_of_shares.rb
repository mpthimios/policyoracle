class ChangeTypeOfShares < ActiveRecord::Migration
	def self.up
		change_column :contracts, :total_shares, :decimal, precision: 15,    scale: 8,   default: 0.00
		change_column :contracts, :market_maker_shares, :decimal, precision: 15,    scale: 8,   default: 0.00
	end

  	def self.down
  		change_column :contracts, :total_shares, :integer
  		change_column :contracts, :market_maker_shares, :integer
	end
end
