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
        self.amount_spent = self.amount_spent + (params.contract_current_value * params.quantity)
        self.quantity = self.quantity + params.quantity
      when 'S'
        self.avg_price = self.amount_spent + (params.contract_current_value * params.quantity)
        self.quantity = self.quantity - params.quantity
        if self.quantity < 0
          self.quantity = 0
        end
        
      else
        #nothing to do
    end
    self.save
  end

end
