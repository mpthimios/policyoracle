class AddTenantToUtransactions < ActiveRecord::Migration
  def change
    add_reference :utransactions, :tenant, index: true
  end
end
