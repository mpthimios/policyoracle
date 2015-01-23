class AddTenantToFeedbacks < ActiveRecord::Migration
  def self.up
    add_reference :feedbacks, :tenant, index: true
  end
  def self.down
    remove_reference :feedbacks, :tenant, index: true
  end
end
