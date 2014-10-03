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

	def close
	    self.market.update(status: 'false')
	    #self.holdings.each do |holding|
	    #	User.find_by(id: holding.user_id).allocate_profit(holding)
	    #end
	    win_id = self.id
	    market = self.market
	    market.contracts.each do |contract|
	    	contract.holdings.each do |holding|
	    		if holding.contract_id == win_id
	    			User.find_by(id: holding.user_id).allocate_profit(holding)
	    		else
	    			User.find_by(id: holding.user_id).allocate_loss(holding)
	    		end
	    	end
	    end
	end 

end
