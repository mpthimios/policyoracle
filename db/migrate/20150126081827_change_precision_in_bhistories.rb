class ChangePrecisionInBhistories < ActiveRecord::Migration
	def self.up
		change_column :bhistories, :profit, :decimal, precision: 15,    scale: 8,   default: 0.00
		change_column :bhistories, :loss, :decimal, precision: 15,    scale: 8,   default: 0.00
	end

  	def self.down
  		change_column :bhistories,	:profit, :decimal, 	precision: 6,    scale: 4,     :default => 0.00
  		change_column :bhistories, 	:loss, :decimal,precision: 6,    scale: 4,     :default => 0.00
	end
end
