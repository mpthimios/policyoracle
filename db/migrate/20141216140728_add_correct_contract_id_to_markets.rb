class AddCorrectContractIdToMarkets < ActiveRecord::Migration
  def up
  	add_reference :markets, :correct_contract, index: true
  end
  def down
  	remove_reference :markets, :correct_contract, index: true
  end
end
