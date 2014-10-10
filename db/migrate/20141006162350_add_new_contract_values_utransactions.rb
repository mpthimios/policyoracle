class AddNewContractValuesUtransactions < ActiveRecord::Migration
  def self.up
    add_column :utransactions, :new_contract_values, :text
    add_column :utransactions, :market_id, :integer
  end
  def self.down
    unless !(column_exists? :utransactions, :new_contract_values)
      remove_column :utransactions, :new_contract_values
    end
    unless !(column_exists? :utransactions, :market_id)
      remove_column :utransactions, :market_id
    end
  end
end
