class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string    	:name            
      t.text      	:description
      t.integer 	:tenant_id
      t.timestamps
    end
    add_index :categories, [:tenant_id]
  end

  def down
    drop_table :categories
  end
end
