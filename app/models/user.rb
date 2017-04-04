class User < ActiveRecord::Base
	has_many :annotations
	has_many :skillsets
	
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

	def get_skills_progress
		if skillsets.length > 0
			return skillsets.last.job_id + 1	
		else
			return 1
		end
	end

	def update_skills_accuracy(new_incoming_accuracy)
		total = skillsets.length.to_f 
		self.skills_accuracy = self.skills_accuracy * (total-1) + new_incoming_accuracy
		self.skills_accuracy /= total 
	end

end
