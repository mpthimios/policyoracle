class User < ActiveRecord::Base

	has_many :holdings
	has_many :utransactions
	has_many :contracts, :through => :holdings
	has_many :contracts, :through => :utransactions

	before_save { self.email = email.downcase }
	before_save { self.name = name.downcase }
	before_create :create_remember_token
	validates :name, presence: true, :length => { maximum: 32 },
					 uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }

  has_secure_password
  #Automatically create the virtual attribute 'password_confirmation'
  validates :password, length: { minimum: 6 }

  scope :sorted, lambda { order("users.rank ASC")}

	def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
