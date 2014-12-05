class ChangeNameTypeOfMarkets < ActiveRecord::Migration
	def self.up
		change_column :markets, :name, :text
	end

  	def self.down
  		change_column :markets, :name, :string
	end
end
