class CreateUsers < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string    :name			
      t.string    :email
      t.string    :password_digest
      t.datetime  :member_date
      t.decimal   :total_amount,        precision: 15,    scale: 8,     default: 200
      t.decimal   :cash_amount,         precision: 15,    scale: 8,     default: 200
      t.decimal   :investment_amount,   precision: 15,    scale: 8,     default: 0
      t.integer   :rank,                default: 0
      t.string    :remember_token
      t.boolean   :admin,               default: false

      # t.datetime "created_at"
      # t.datetime "updated_at"
      t.timestamps
    end
    add_index :users, :email,           unique: true
    add_index :users, :name,            unique: true
    add_index :users, :remember_token
  end

  def down
    drop_table :users
  end

end
