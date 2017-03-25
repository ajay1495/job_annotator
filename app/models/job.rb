class Job < ActiveRecord::Base
	has_many :annotations
	has_many :skills
end
