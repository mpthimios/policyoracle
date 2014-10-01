class Holding < ActiveRecord::Base

	belongs_to :user
	belongs_to :contract
	#default_scope -> { order('created_at DESC') }

	validates :user_id, presence: true
	validates :contract_id, presence: true
	validates :quantity, :numericality => {greater_than_or_equal_to: 1}, presence: true

  def update_attributes(params)
    existed_holding = Holding.find_by(params.contract_id, params.user_id)
    if existed_holding
      case params.transaction_type
        when 'B'
          existed_holding.quantity = existed_holding.quantity + params.quantity
          #self.price_purchased = params.contract_current_value
        when 'S'
          existed_holding.quantity = existed_holding.quantity - params.quantity
          if existed_holding.quantity < 0
            existed_holding.quantity = 0
          end
          #self.price_purchased = utransaction.contract_current_value
        else
          #nothing to do
      end
      existed_holding.save
    else
      case params.transaction_type
        when 'B'
          self.quantity = self.quantity + params.quantity
          #self.price_purchased = params.contract_current_value
        when 'S'
          self.quantity = self.quantity - params.quantity
          if self.quantity < 0
            self.quantity = 0
          end
          #self.price_purchased = utransaction.contract_current_value
        else
          #nothing to do
      end
      self.save
    end
  end

end
