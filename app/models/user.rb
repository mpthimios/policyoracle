class User < ActiveRecord::Base

	has_many :holdings
	has_many :utransactions
	has_many :contracts, :through => :holdings
	has_many :contracts, :through => :utransactions

	before_save { self.email = email.downcase }
	before_save { self.name = name.downcase }
	validates :name, presence: true, :length => { maximum: 32 },
					 uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }

    has_secure_password
    #Automatically create the virtual attribute 'password_confirmation'
    validates :password, length: { minimum: 6 }

    scope :sorted, lambda { order("users.rank ASC")}

end
