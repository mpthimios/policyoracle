class CreateContracts < ActiveRecord::Migration

  def up
    create_table :contracts do |t|
      t.string :name, 				:limit => 100		
      t.decimal :current_price, 	precision: 8,	scale: 2
      t.decimal :closing_price, 	precision: 8,	scale: 2
      t.decimal :opening_price, 	precision: 8,	scale: 2
      t.datetime :opening_date
      t.datetime :end_date
      t.float :total_shares, default:  0
      t.float :total_amount_wagered, default:  0
      t.integer :volume_traded
      t.boolean :status,			default: "0"
      t.integer :position
      t.references :market

      # t.datetime "created_at"
      # t.datetime "updated_at"
      t.timestamps
    end
    add_index :contracts, ["market_id"]
  end

  def down
    drop_table :contracts
  end
  
end
