class CreateUsers < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string :name			
      t.string :email
      t.string :password_digest
      t.datetime :member_date
      t.float :total_amount,    default: "200"
      t.float :cash_amount,     default: "200"
      t.float :investment_amount
      t.integer :rank  

      # t.datetime "created_at"
      # t.datetime "updated_at"
      t.timestamps
    end
  end

  def down
    drop_table :users
  end

end
