class AddDemographicInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :country, 			:string
    add_column :users, :gender, 			:string
    add_column :users, :birth_year, 		:integer
    add_column :users, :education, 			:string
    add_column :users, :market_knowledge, 	:string
  end
  def self.down
    remove_column :users, :country, 		:string
    remove_column :users, :gender, 			:string
    remove_column :users, :birth_year, 		:integer
    remove_column :users, :education, 		:string
    remove_column :users, :market_knowledge,:string
  end
end
