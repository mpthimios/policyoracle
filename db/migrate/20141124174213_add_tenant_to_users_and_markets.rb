class AddTenantToUsersAndMarkets < ActiveRecord::Migration
  def self.up
    add_reference :users, :tenant, index: true
    add_reference :markets, :tenant, index: true
  end
  def self.down
    remove_reference :users, :tenant, index: true
    remove_reference :markets, :tenant, index: true
  end
end
