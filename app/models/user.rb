class User < ActiveRecord::Base
	has_many :annotations
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	before_save { self.email = email.downcase }

	validates :email, presence: {message: "Please provide an email."}, uniqueness: {case_sensitive: false, message: "This email has already been taken."}, 
					  length: { maximum: 255 },
	                  format: { with: VALID_EMAIL_REGEX, message: "Please provide a valid email address."}

	def User.digest(string)
	  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                BCrypt::Engine.cost
	  BCrypt::Password.create(string, cost: cost)
	end

	

end
