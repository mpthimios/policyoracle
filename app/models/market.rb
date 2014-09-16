class Market < ActiveRecord::Base
	has_many :contracts

	# you need to add a position column to desired table:
	# acts_as_list

	CATEGORY_TYPES = ['Economics', 'Politics', 'Environment']

	validates_presence_of :name, :description, :published_date, :arbitration_date
	validates_length_of :name, :maximum => 255
	validates_uniqueness_of :name
	validates_inclusion_of :category, :in => CATEGORY_TYPES, :message => "must be one of: #{CATEGORY_TYPES.join(',')}"
	validates_presence_of :category

  scope :sorted, lambda { order("markets.id ASC")}
  scope :newest_first, lambda { order("markets.published_date DESC")}

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
          when 'S'
            contract[:total_shares] = contract[:total_shares] - params.quantity
        end
        value = Math.exp(contract[:total_shares]/self.b_value)
      end
      denominator = denominator + value
      numerators[contract[:id]] =  value
    end

    sum_of_prices = 0.0
    self.contracts.each do |contract|
      contract.current_price = numerators[contract[:id]]/denominator
      contract.save
      sum_of_prices = sum_of_prices + contract.current_price
      logger.debug "the sum_of_prices is " + sum_of_prices.to_s
    end

    cost = self.b_value*Math.log(denominator) - self.b_value*Math.log(sum_before)

  end

end
