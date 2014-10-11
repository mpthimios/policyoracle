class Market < ActiveRecord::Base
	has_many :contracts, :dependent => :destroy
  has_many :microposts

  accepts_nested_attributes_for :contracts

	# you need to add a position column to desired table:
	# acts_as_list

	#CATEGORY_TYPES = ['Economics', 'Politics', 'Environment']

	validates_presence_of :name, :description, :published_date, :arbitration_date, :category
	validates_length_of :name, :maximum => 255
	validates_uniqueness_of :name
	#validates_inclusion_of :category, :in => CATEGORY_TYPES, :message => "must be one of: #{CATEGORY_TYPES.join(',')}"

  scope :sorted, lambda { order("markets.id ASC")}
  scope :newest_first, lambda { order("markets.published_date DESC")}

  before_create :choose_b

  def choose_b
    users_default_cash_amount = 200.0
    number_of_users = User.count.to_f
    number_of_contracts = 2.0
    unless !self.contracts.nil?
      number_of_contracts = self.contracts.size.to_f
    end
    initial_price = 1.0/number_of_contracts
    price_change_to = 0.99

    logger.debug number_of_users
    logger.debug number_of_contracts
    logger.debug initial_price

    self.b_value = ((-1.0 ) * number_of_users * users_default_cash_amount) / \
      Math.log((number_of_contracts * (1 - price_change_to)) / (number_of_contracts - 1))
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
    numerators = Hash.new
    self.contracts.each do |contract|
      value = Math.exp(contract[:total_shares]/self.b_value)
      sum_before = sum_before + value
      if contract[:id] == params.contract_id
        case params.transaction_type
          when 'B'
            contract[:total_shares] = contract[:total_shares] + params.quantity
            cur_price = contract[:current_price]
            logger.debug "the price purchased is " + cur_price.to_s
          when 'S'
            contract[:total_shares] = contract[:total_shares] - params.quantity
            cur_price = contract[:current_price]
        end
        value = Math.exp(contract[:total_shares]/self.b_value)
      end
      denominator = denominator + value
      numerators[contract[:id]] =  value
    end

    sum_of_prices = 0.0
    self.contracts.each do |contract|
      contract.current_price = numerators[contract[:id]]/denominator
      contract.save!
      sum_of_prices = sum_of_prices + contract.current_price
      logger.debug "the sum_of_prices is " + sum_of_prices.to_s
    end

    if params.transaction_type == 'B'
      cost = (self.b_value*Math.log((cur_price*(Math.exp(params.quantity/self.b_value)-1))+1)).ceil
    elsif params.transaction_type == 'S'
      cost = (self.b_value*Math.log((cur_price*(Math.exp(params.quantity/self.b_value)-1))+1)).floor
    end
    #cost = self.b_value*Math.log(denominator) - self.b_value*Math.log(sum_before)

      
  end

end
