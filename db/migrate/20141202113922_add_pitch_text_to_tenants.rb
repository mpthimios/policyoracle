class AddPitchTextToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :pitch_text, :string
  end
end
