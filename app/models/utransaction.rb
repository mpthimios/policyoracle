class Utransaction < ActiveRecord::Base

  before_save :update_market_holdings_and_money

  belongs_to :user
  belongs_to :contract

  validates :user_id, presence: true
  validates :contract_id, presence: true
  validates :quantity, :numericality => {greater_than_or_equal_to: 1}, presence: true

  after_validation :update_market_holdings_and_money, :on => :update

  def update_market_holdings_and_money

    logger.debug "update_market_holdings_and_money"

    cost = Contract.find_by_id(self.contract_id).market.update_market(self)
    logger.debug self.user.cash_amount += (-1) * cost
    logger.debug self.user.investment_amount += (-1) * cost

    #logger.debug self.user.save
    logger.debug "the transaction cost is: " + cost.to_s
    Holding.find_or_initialize_by(user_id: self.user_id, contract_id: self.contract_id, price_purchased: contract_current_value) \
      .update_attributes(self)
  end

end
