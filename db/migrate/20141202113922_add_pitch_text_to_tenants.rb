class AddPitchTextToTenants < ActiveRecord::Migration
  def self.up
    add_column :tenants, :pitch_text, :string
  end
  def self.down
    remove_column :tenants, :pitch_text, :string
  end
end
