class AddTenantToUsersAndMarkets < ActiveRecord::Migration
  def change
    add_reference :users, :tenant, index: true
    add_reference :markets, :tenant, index: true
  end
end
