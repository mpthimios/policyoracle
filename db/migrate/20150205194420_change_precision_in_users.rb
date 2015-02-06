class ChangePrecisionInUsers < ActiveRecord::Migration
  def self.up
		change_column :users, :total_amount, :decimal, :precision => 15, :scale => 4
		change_column :users, :cash_amount, :decimal, :precision => 15, :scale => 4
		change_column :users, :investment_amount, :decimal, :precision => 15, :scale => 4
	end

  	def self.down
  		change_column :users, :total_amount, :decimal, :precision => 15, :scale => 8
  		change_column :users, :cash_amount, :decimal, :precision => 15, :scale => 8
  		change_column :users, :investment_amount, :decimal, :precision => 15, :scale => 8
	end
end
