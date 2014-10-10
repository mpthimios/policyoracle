class CreateBhistories < ActiveRecord::Migration
  
  def up
    create_table :bhistories do |t|
    	t.integer   :user_id
    	t.integer   :contract_id
    	t.decimal	  :profit,  		 precision: 6,    scale: 4,     :default => 0.00
      t.decimal   :loss,         precision: 6,    scale: 4,     :default => 0.00

      t.timestamps
    end
    add_index :bhistories, [:user_id, :contract_id]
  end

  def down
    drop_table :bhistories
  end
end
