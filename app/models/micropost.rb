class Micropost < ActiveRecord::Base
	belongs_to :user
	belongs_to :market
	
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 200 }
	validates :user_id, presence: true
	validates :market_id, presence: true
end
