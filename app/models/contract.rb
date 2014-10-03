class Contract < ActiveRecord::Base

	belongs_to :market
	has_many :holdings
	has_many :utransactions
	has_many :bhistories
	has_many :users, :through => :holdings
	has_many :users, :through => :utransactions
	has_many :users, :through => :bhistories

	validates_presence_of :name, :market_id, :opening_price
	validates_length_of :name, :maximum => 255

	scope :sorted, lambda { order("contracts.name ASC")}

end
