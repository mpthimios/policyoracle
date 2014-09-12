class Holding < ActiveRecord::Base

	belongs_to :user
	belongs_to :contract
	#default_scope -> { order('created_at DESC') }

	validates :user_id, presence: true
	validates :contract_id, presence: true
	validates :quantity, :numericality => {greater_than_or_equal_to: 1}, presence: true

end
