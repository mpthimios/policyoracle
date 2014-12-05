class AddTagsToMarkets < ActiveRecord::Migration
  def self.up
    add_column :markets, :tags, :string
  end
   def self.down
    remove_column :markets, :tags, :string
  end
end
