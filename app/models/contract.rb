class Contract < ActiveRecord::Base

	belongs_to :market
	has_many :holdings
	has_many :utransactions
	has_many :users, :through => :holdings
	has_many :users, :through => :utransactions


	validates_presence_of :name, :market_id, :opening_price
	validates_length_of :name, :maximum => 255
	validates_uniqueness_of :name

	scope :sorted, lambda { order("contracts.id ASC")}


end
