class Utransaction < ActiveRecord::Base

  include TenantScoped

  before_save :update_market_holdings_and_money

  belongs_to :user
  belongs_to :contract
  belongs_to :market

  validates :user_id, presence: true
  validates :contract_id, presence: true
  validates :quantity, :numericality => {greater_than_or_equal_to: 1, message: "of shares should be greater than 0" }, presence: true 
  validates :comment, length: { maximum: 140 }

  after_validation :update_market_holdings_and_money, :on => :update

  serialize :new_contract_values

  def update_market_holdings_and_money(save = true)

    logger.debug "update_market_holdings_and_money"

    market = Contract.find_by_id(self.contract_id).market
    cost = BigDecimal(market.update_market(self).to_s)
    logger.debug "the transaction cost is: " + cost.to_s
    self.cost = cost
    logger.debug "self transaction cost is: " + self.cost.to_s
    self.market = market
    case self.transaction_type
      when 'B'
        self.user.cash_amount = self.user.cash_amount - cost
      when 'S'
        self.user.cash_amount = self.user.cash_amount + cost
    end

    if save
      self.user.save!
      Holding.find_or_initialize_by(user_id: self.user_id, contract_id: self.contract_id) \
        .update_attributes(self)
      new_contract_values = {}
      market.contracts.each do |contract|
        new_contract_values[contract.id] = contract.current_price
        contract.total_amount_wagered = contract.total_amount_wagered + cost
        logger.debug "the new contract value is: " + contract.current_price.to_s
        contract.save!
      end
      self.new_contract_values = new_contract_values
      self.contract_new_value = new_contract_values[contract_id]
      logger.debug "contract values done "
    end
  end

  def simulate
    update_market_holdings_and_money(save = false)
    data = {}
    if transaction_type == 'S'
      holding = self.user.holdings.where(contract_id: self.contract_id).first
      unless holding.nil?
        data[:current_quantity] = holding.quantity
      else
        data[:current_quantity] = 0
      end
    end
    data[:cost] = 100*self.cost
    data[:cash] = 100*self.user.cash_amount
    #logger.debug "the cost is: " + self.cost.to_s
    #logger.debug "the cash is: " + self.user.cash_amount.to_s

    data[:contracts] = {}
    self.market.contracts.each do |contract|
      data[:contracts][contract.id] = 100*contract.current_price.round(4)
    end
    data
  end

end