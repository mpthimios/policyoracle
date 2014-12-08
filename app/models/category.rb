class Category < ActiveRecord::Base
	belongs_to :tenant
	
	validates :name, presence: true, length: { maximum: 200 }
	validates :tenant_id, presence: true
end