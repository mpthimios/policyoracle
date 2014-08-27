class User < ActiveRecord::Base

	has_secure_password
	
	has_many :holdings
	has_many :utransactions
	has_many :contracts, :through => :holdings
	has_many :contracts, :through => :utransactions

	validates :name, presence: true, :length => { :within => 8..25 },
                       :uniqueness => true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

    scope :sorted, lambda { order("users.rank ASC")}
end
