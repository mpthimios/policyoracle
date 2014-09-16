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
        self.price_purchased = 10
      when 'S'
        self.quantity = self.quantity - params.quantity
        if self.quantity < 0
          self.quantity = 0
        end
        self.price_purchased = 10
      else
        #nothing to do
    end
    self.save
  end

end
