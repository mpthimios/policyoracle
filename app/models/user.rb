class User < ActiveRecord::Base

  include TenantScoped

	has_many :holdings 
	has_many :utransactions 
  has_many :bhistories 
	has_many :contracts, :through => :holdings 
	has_many :contracts, :through => :utransactions
  has_many :contracts, :through => :bhistories
  has_many :microposts, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token
	before_save { self.email = email.downcase }
	before_save { self.name = name.downcase }
	before_create :create_remember_token
  before_create :create_activation_digest
  after_create :update_markets
  GENDER_TYPES = ['Male', 'Female']
  EDUCATION = ['High school', 'Bachelor/College degree', 'Master degree', 'PhD/Post-grad research degree']
  MARKET_KNOWLEDGE = ['Excellent', 'Very Good', 'Good', 'Low', 'Very Low', 'None']
	#validates :name, presence: true, :length => { maximum: 32 },
	#				 uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates_numericality_of :total_amount, :greater_than_or_equal_to => 0, :message => " cant be negative" 
  validates_numericality_of :investment_amount, :greater_than_or_equal_to => 0, :message => "cant be negative"
  validates_numericality_of :cash_amount, :greater_than_or_equal_to => 0, :message => " cant be negative"
  
  has_secure_password
  #Automatically create the virtual attribute 'password_confirmation'
  validates :password, length: { minimum: 6 }, :if => :validate_password?

  attr_accessor :country_code

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

  # Activates an account.
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

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

    # Sends email for weekly activities
  def self.mail_recap_week
    tenants = Tenant.all
    tenants.each do |tenant|
      @tenant = Tenant.current = tenant
      logger.debug(@tenant)
      @users = User.all
      @users.each do |user|
        UserMailer.mail_recap_week(user.email).deliver
      end
    end
  end

  def update_markets
    markets = Market.all
    markets.each do |market|
      if market.status == true
        market.choose_b
        market.market_maker_buys_shares
        market.save
      end
    end
  end

  def allocate_profit(params)
    profit = params.quantity - params.amount_spent
    logger.debug "the profit is: " + profit.to_s

    self.cash_amount = self.cash_amount + params.quantity
    logger.debug "the cash amount is: " + self.cash_amount.to_s

    self.save!

    bhistory = Bhistory.new(user_id: self.id, contract_id: params.contract_id, profit: profit)
    bhistory.save!
  end

  def allocate_loss(params)

    logger.debug "the loss is: " + params.amount_spent.to_s
    
    bhistory = Bhistory.new(user_id: self.id, contract_id: params.contract_id, loss: params.amount_spent)
    bhistory.save!
  end

  def country_name
    country = Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end
  
  def get_gender_types
    GENDER_TYPES
  end

  def get_education_types
    EDUCATION
  end
  
  def get_market_knowledge_types
    MARKET_KNOWLEDGE
  end

  def get_years_of_birth
    select_year(Date.today, start_year: 2005, end_year: 1920)
  end

  def self.update_ranking
    #operations are performed for all tenants
    tenants = Tenant.all
    tenants.each do |tenant|
      #first update the worth of all users
      @tenant = Tenant.current = tenant
      logger.debug(@tenant)
      @users = User.all
      @users.each do |user|
        user.calculate_worth
      end
      #then update the rank
      rankedUsers = User.order("worth DESC")
      rankedUsers.each_with_index do |user, index|
        user.rank = index + 1
        user.save
      end
    end
  end

  def calculate_worth
    holdings_worth = 0.0
    holdings = self.holdings.select{|h| h.market.status == true}
    holdings.each do |holding|
      utransaction = Utransaction.new
      utransaction.transaction_type = 'S'
      utransaction.quantity = holding.quantity
      utransaction.contract_id = holding.contract_id
      utransaction.user_id = self.id
      data = utransaction.simulate
      holdings_worth = holdings_worth + data[:cost]/100
    end
    self.worth = holdings_worth + self.cash_amount
    self.worth_updated_at = DateTime.now
    save
  end

  private
    
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def validate_password?
      password_digest.nil?
    end
    
    # Creates and assigns the activation token and digest.
    def create_activation_digest
    # Create the token and digest.
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
