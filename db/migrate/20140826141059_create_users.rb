class CreateUsers < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string "name", 			:limit => 32		
      t.string "email", 			:default => "", 	:null => false	
      t.string "password", 			:limit => 32
      t.datetime "member_date"
      t.string "activation_key", 	:limit => 100
      t.boolean "status",			:default => "0"
      t.float "total_amount",   :default => "200"
      t.float "cash_amount",    :default => "200"
      t.float "investment_amount",  :default => ""
      t.integer "rank"  

      # t.datetime "created_at"
      # t.datetime "updated_at"
      t.timestamps
    end
  end

  def down
    drop_table :users
  end

end
