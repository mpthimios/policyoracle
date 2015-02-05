class ChangePrecisionInUsers < ActiveRecord::Migration
  def change
    change_column :users, :total_amount, :decimal, :precision => 15, :scale => 2
    change_column :users, :cash_amount, :decimal, :precision => 15, :scale => 2
    change_column :users, :investment_amount, :decimal, :precision => 15, :scale => 2
  end
end
