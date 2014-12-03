class ChangeNameTypeOfMarkets < ActiveRecord::Migration
  def change
  	change_column :markets, :name, :text
  end
end
