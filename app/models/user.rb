class User < ActiveRecord::Base

	has_many :holdings 
	has_many :utransactions 
  has_many :bhistories 
	has_many :contracts, :through => :holdings 
	has_many :contracts, :through => :utransactions
  has_many :contracts, :through => :bhistories
  has_many :microposts, dependent: :destroy

	before_save { self.email = email.downcase }
	before_save { self.name = name.downcase }
	before_create :create_remember_token
  after_save :update_markets
	#validates :name, presence: true, :length => { maximum: 32 },
	#				 uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }

  has_secure_password
  #Automatically create the virtual attribute 'password_confirmation'
  validates :password, length: { minimum: 6 }, :if => :validate_password?

  scope :sorted, lambda { order("users.rank ASC")}

	def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def update_markets
    markets = Market.all
    markets.each do |market|
      market.choose_b
      market.save
    end
  end

  def allocate_profit(params)
    profit = params.quantity - params.amount_spent
    logger.debug "the profit is: " + profit.to_s

    self.total_amount = self.total_amount + profit
    logger.debug "the total amount is: " + self.total_amount.to_s

    self.investment_amount = self.investment_amount - params.amount_spent
    logger.debug "the investment_amount is: " + self.investment_amount.to_s

    self.cash_amount = self.cash_amount + params.quantity
    logger.debug "the cash amount is: " + self.cash_amount.to_s

    self.save!

    bhistory = Bhistory.new(user_id: self.id, contract_id: params.contract_id, profit: profit)
    bhistory.save!
  end

  def allocate_loss(params)
    self.total_amount = self.total_amount - params.amount_spent
    logger.debug "the total amount is: " + self.total_amount.to_s

    self.investment_amount = self.investment_amount - params.amount_spent
    logger.debug "the investment_amount is: " + self.investment_amount.to_s

    self.save!

    logger.debug "the loss is: " + params.amount_spent.to_s

    bhistory = Bhistory.new(user_id: self.id, contract_id: params.contract_id, loss: params.amount_spent)
    bhistory.save!
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def validate_password?
      password_digest.nil?
    end

end
