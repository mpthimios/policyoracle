class Bhistory < ActiveRecord::Base

	belongs_to :user
	belongs_to :contract
	
	validates :user_id, presence: true
	validates :contract_id, presence: true
	
end
