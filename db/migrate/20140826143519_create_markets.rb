class CreateMarkets < ActiveRecord::Migration

  def up
    create_table :markets do |t|
      t.string :name,        :limit => 100   
      t.string :category,      :limit => 32
      t.text :description
      t.datetime :published_date
      t.datetime :arbitration_date
      t.integer :shares_to_users
      t.string :mechanism, :limit => 5, :default => "AMM"
      t.boolean :status,     :default => "0"
      t.float :b_value, :default => 10.0

      t.timestamps
    end
  end

  def down
    drop_table :markets
  end
  
end
