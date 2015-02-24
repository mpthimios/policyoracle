class Market < ActiveRecord::Base

  include TenantScoped
	has_many :contracts, :dependent => :destroy, :inverse_of => :market
  has_many :microposts
  has_many :utransactions
  has_many :holdings

  accepts_nested_attributes_for :contracts

	# you need to add a position column to desired table:
	# acts_as_list


  MARKET_TYPES = ['Yes/No', 'Multiple Choices']

	validates_presence_of :name, :description, :published_date, :arbitration_date, :category
	validates_length_of :name, :maximum => 255
	validates_uniqueness_of :name, scope: :tenant_id
	
  validates_inclusion_of :market_type, :in => MARKET_TYPES, :message => "must be one of: #{MARKET_TYPES.join(',
')}"

  scope :sorted, lambda { order("markets.id ASC")}
  scope :newest_first, lambda { order("markets.published_date DESC")}

  accepts_nested_attributes_for :contracts

  before_create :choose_b, :fill_attributes

  def choose_b
    users_total_cash_amount = 0
    users = User.all
    users.each do |user|
      users_total_cash_amount = users_total_cash_amount + user.cash_amount
    end
    number_of_contracts = 2.0
    unless !self.contracts.nil?
      number_of_contracts = self.contracts.size.to_f
    end
    initial_price = 1.0/number_of_contracts
    price_change_to = 0.99

    logger.debug users_total_cash_amount
    logger.debug number_of_contracts
    logger.debug initial_price

    self.b_value = ((-1.0 ) * users_total_cash_amount) / \
      Math.log((number_of_contracts * (1 - price_change_to)) / (number_of_contracts - 1))
  end

  def market_maker_buys_shares
    b = self.b_value
    self.contracts.each do |contract|
      shares_to_purchase =  b * Math.log(contract.current_price)
      contract.market_maker_shares = contract.market_maker_shares + shares_to_purchase
      contract.total_shares = shares_to_purchase
    end
  end

  def fill_attributes
    opening_price = 1/self.contracts.size.to_f
    self.contracts.each do |contract|
      contract.opening_price = opening_price
      contract.current_price = opening_price
    end
    self.status = 1
  end

  def update_market(params)
    logger.debug "entered update_market"
    cost = 0.0
    case self.mechanism
      when "AMM"
        cost = update_AMM_market(params)
      else
        #nothing to do
    end
    cost
  end

  def update_AMM_market(params)
    logger.debug self.contracts.count
    #update contract prices
    cur_price = 0.0
    sum_before = 0.0
    denominator = 0.0
    cost = 0.0
    numerators = Hash.new

    self.contracts.each do |contract|
      if contract[:id] == params.contract_id
        case params.transaction_type
          when 'B'
            contract[:total_shares] = contract[:total_shares] + params.quantity
            contract[:volume_traded] = contract[:volume_traded] + params.quantity
            cur_price = contract[:current_price]
          when 'S'
            contract[:total_shares] = contract[:total_shares] - params.quantity
            contract[:volume_traded] = contract[:volume_traded] - params.quantity
            cur_price = contract[:current_price]
        end
      end
    end

    self.contracts.each do |contract|
      value = Math.exp(contract[:total_shares]/self.b_value)

      logger.debug "contract id:" + contract[:id].to_s
      logger.debug "total shares are " + contract[:total_shares].to_s
      logger.debug "the value is" + value.to_s
      
      sum_before = sum_before + value
      denominator = denominator + value
      numerators[contract[:id]] =  value
    end

    logger.debug "the denominator is" + denominator.to_s

    sum_of_prices = 0.0

    self.contracts.each do |contract|
      contract.current_price = numerators[contract[:id]]/denominator
      #contract.save!
      sum_of_prices = sum_of_prices + contract.current_price
      logger.debug "contract price:" + contract.current_price.to_s
      logger.debug "the sum_of_prices is " + sum_of_prices.to_s
    end

    if params.transaction_type == 'B'
      cost = (self.b_value*Math.log((cur_price*(Math.exp((params.quantity)/self.b_value)-1))+1))
      cost = cost.ceil2(4)
    elsif params.transaction_type == 'S'
      cost = (-self.b_value*Math.log((cur_price*(Math.exp((-params.quantity)/self.b_value)-1))+1))
      cost = cost.floor2(4)
    end
    cost
    #cost = self.b_value*Math.log(denominator) - self.b_value*Math.log(sum_before) 

  end

  def graph_data
    data = {}
    data[:prices] = []
    data[:volume] = []
    data[:dates] = []
    self.contracts.each do |contract|
      data[:prices] << {:key => contract.name, :values => []}
    end

    #add the initial value
    i=0
    self.contracts.each do |contract|
      data[:prices][i][:values] << contract.opening_price.round(2)
      i = i + 1
    end
    data[:dates] << self.created_at.strftime("%Y-%m-%d %H:%M")
    data[:volume] << 0

    #add transactions
    n = 1
    self.utransactions.order("created_at").each do |transaction|

      date = transaction.created_at.strftime("%Y-%m-%d %H:%M")
      index = data[:dates].index(date)

      if index.nil?
        new_contract_values = transaction.new_contract_values
        i = 0
        new_contract_values.each do |key, value|
          data[:prices][i][:values] << value.round(2)
          i +=1
        end
        data[:dates] << date
        data[:volume] << transaction.quantity
        i = 1
      else
        i = 0
        n=n+1
        new_contract_values = transaction.new_contract_values
        new_contract_values.each do |key, value|
          data[:prices][i][:values][index] = ((n-1)*data[:prices][i][:values][index] + value.round(2))/n
          i +=1
        end
        data[:volume][index] = ((n-1)*data[:volume][index] + transaction.quantity)/n
      end
    end

    #add another point for the current time
    i=0
    self.contracts.each do |contract|
      data[:prices][i][:values] << contract.current_price.round(2)
      i = i + 1
    end
    data[:dates] << DateTime.now.strftime("%Y-%m-%d %H:%M")
    data[:volume] << 0

    data
  end


  def get_market_types
    MARKET_TYPES
  end

end
