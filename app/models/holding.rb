class Holding < ActiveRecord::Base

	belongs_to :user
	belongs_to :contract
	#default_scope -> { order('created_at DESC') }

	validates :user_id, presence: true
	validates :contract_id, presence: true
	validates :quantity, :numericality => {greater_than_or_equal_to: 1}, presence: true

  def update_attributes(params)
    case params.transaction_type
      when 'B'
        self.quantity = self.quantity + params.quantity
        self.amount_spent = self.amount_spent + params.cost
      when 'S'
        self.quantity = self.quantity - params.quantity
        self.amount_spent = self.amount_spent - params.cost
        if self.quantity < 0 || self.quantity == 0
          self.destroy
        end
        diff = params.cost - self.amount_spent
        self.user.investment_amount += (-1) * self.amount_spent
        self.user.cash_amount += (1) * params.cost
        self.user.total_amount += (1) * diff
        self.user.save!
        if params.cost >= self.amount_spent 
          bhistory = Bhistory.new(user_id: self.id, contract_id: self.contract_id, profit: diff)
        else
          bhistory = Bhistory.new(user_id: self.id, contract_id: self.contract_id, loss: diff )
        end
        
      else
        #nothing to do
    end
    self.save
  end

  def sell
    avg_contract_price = self.amount_spent / self.quantity
    Utransaction.new(transaction_type: "Sell",         user_id: self.user_id, 
                        contract_id: self.contract_id, quantity: self.quantity,
                        contract_current_value: avg_contract_price)
  end

end
