class Utransaction < ActiveRecord::Base

  before_save :update_market_holdings_and_money

  belongs_to :user
  belongs_to :contract
  belongs_to :market

  validates :user_id, presence: true
  validates :contract_id, presence: true
  validates :quantity, :numericality => {greater_than_or_equal_to: 1}, presence: true

  after_validation :update_market_holdings_and_money, :on => :update

  serialize :new_contract_values

  def update_market_holdings_and_money

    logger.debug "update_market_holdings_and_money"

    market = Contract.find_by_id(self.contract_id).market
    cost = market.update_market(self)
    self.cost = cost
    self.market = market
    self.user.cash_amount += (-1) * cost
    self.user.investment_amount += (1) * cost
    self.user.save
    logger.debug "the transaction cost is: " + cost.to_s
    Holding.find_or_initialize_by(user_id: self.user_id, contract_id: self.contract_id) \
      .update_attributes(self)

    new_contract_values = {}
    market.contracts.each do |contract|
      new_contract_values[contract.id] = contract.current_price
    end
    self.new_contract_values = new_contract_values


  end

end
