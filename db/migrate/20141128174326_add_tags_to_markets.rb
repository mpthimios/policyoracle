class AddTagsToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :tags, :string
  end
end
