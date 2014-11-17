class Utransaction < ActiveRecord::Base

  before_save :update_market_holdings_and_money

  belongs_to :user
  belongs_to :contract
  belongs_to :market

  validates :user_id, presence: true
  validates :contract_id, presence: true
  validates :quantity, :numericality => {greater_than_or_equal_to: 1}, presence: true
  validates :comment, length: { maximum: 140 }

  after_validation :update_market_holdings_and_money, :on => :update

  serialize :new_contract_values

  def update_market_holdings_and_money(save = true)

    logger.debug "update_market_holdings_and_money"

    market = Contract.find_by_id(self.contract_id).market
    cost = market.update_market(self)
    self.cost = cost
    self.market = market
    case self.transaction_type
      when 'B'
        self.user.cash_amount = self.user.cash_amount - cost
        self.user.investment_amount += (1) * cost
    end
    #self.user.save!
    logger.debug "the transaction cost is: " + cost.to_s
    #Holding.find_or_initialize_by(user_id: self.user_id, contract_id: self.contract_id) \
    #  .update_attributes(self)

    if save
      self.user.save!
      Holding.find_or_initialize_by(user_id: self.user_id, contract_id: self.contract_id) \
        .update_attributes(self)
      new_contract_values = {}
      market.contracts.each do |contract|
        new_contract_values[contract.id] = contract.current_price
        logger.debug "the new contract value is: " + contract.current_price.to_s
        contract.save!
      end
      self.new_contract_values = new_contract_values
    end
  end

  def simulate
    update_market_holdings_and_money(save = false)
    data = {}
    data[:cost] = self.cost.round(2)
    data[:cash] = self.user.cash_amount.round(2)
    data[:contracts] = {}
    self.market.contracts.each do |contract|
      data[:contracts][contract.id] = contract.current_price.round(4)*100
    end
    data
  end

end
