class CreateContracts < ActiveRecord::Migration

  def up
    create_table :contracts do |t|
      t.string      :name 						
      t.decimal     :current_price, 	     precision: 15,	   scale: 8,   default: 0.00
      t.decimal     :closing_price, 	     precision: 15,	   scale: 8,   default: 0.00
      t.decimal     :opening_price, 	     precision: 15,	   scale: 8
      t.datetime    :opening_date
      t.datetime    :end_date
      t.integer     :total_shares,         default:  0
      t.decimal     :total_amount_wagered, precision: 15,    scale: 8,   default: 0.00
      t.integer     :volume_traded,        default:  0
      t.boolean     :status,			         default: "0"
      t.references  :market

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
