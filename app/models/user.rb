class User < ActiveRecord::Base

	has_many :holdings 
	has_many :utransactions 
  has_many :bhistories 
	has_many :contracts, :through => :holdings 
	has_many :contracts, :through => :utransactions
  has_many :contracts, :through => :bhistories
  has_many :microposts, dependent: :destroy

  attr_accessor :remember_token, :activation_token
	before_save { self.email = email.downcase }
	before_save { self.name = name.downcase }
	before_create :create_remember_token
  before_create :create_activation_digest
  after_save :update_markets
	#validates :name, presence: true, :length => { maximum: 32 },
	#				 uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_secure_password
  #Automatically create the virtual attribute 'password_confirmation'
  validates :password, length: { minimum: 6 }, :if => :validate_password?

  scope :sorted, lambda { order("users.rank ASC")}

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end


  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
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

    def create_activation_digest
    # Create the token and digest.
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
