class CreateMarkets < ActiveRecord::Migration

  def up
    create_table :markets do |t|
      t.string    :name                
      t.string    :category         
      t.text      :description
      t.string    :type
      t.datetime  :published_date
      t.datetime  :arbitration_date
      t.integer   :shares_to_users,     default: 0
      t.string    :mechanism,           default: "AMM"
      t.boolean   :status,              default: false
      t.float     :b_value,             default: 10.0

      t.timestamps
    end
  end

  def down
    drop_table :markets
  end
  
end
