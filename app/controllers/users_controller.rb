class UsersController < ApplicationController
	def currentUser
		# @current_user is stored as instance variable, so if currentUser 
		# is used multiple times a database search isn't done every time
		@current_user ||= User.find_by(id: session[:user_id])
	end

	def update
		@curUser = currentUser
		@curUser.email = ""
	end

	# Logs in the given user.
	def login_session(user)
	  	session[:user_id] = user.id
	end

	def logout
		session.delete(:user_id)
		redirect_to("https://stella.ai/")
	end

	def login
		if !params[:v] or !User.find_by_digest(params[:v])
			redirect_to("https://stella.ai/")
		else 
			@userToLogin = User.find_by_digest(params[:v])			
			login_session(@userToLogin)

			if !@userToLogin.is_initialized 
				redirect_to("/users/update")
			else
				redirect_to("/skills/annotate/#{@userToLogin.get_skills_progress}")
			end
		end
	end

	def analyze_candidates
		@LIMIT = 20 
		filteredUsers = User.where("progress >= ?", @LIMIT) # Do not allow any other candidates
		oracleUser = User.find_by_email("ajay14@stanford.edu")

		@candidatesAnalysis = []

		filteredUsers.each do |candidate| 
			totalScore = 0.0 
			for jobId in 1..@LIMIT-1
				@jobToAnnotate = Job.find_by_id(jobId)
				puts jobId
				annotationByCandidate = Annotation.where(user: candidate).order('created_at ASC')[jobId-1]

				if !annotationByCandidate.job
					annotationByCandidate.job = @jobToAnnotate
					annotationByCandidate.save 
				end

				oracleAnnotation = Annotation.find_by(user: oracleUser, job_id: @jobToAnnotate.id)

				annotationScore = Annotation.compute_similarity(annotationByCandidate, oracleAnnotation)
				totalScore += annotationScore
			end

			averageAnnotationScore = totalScore / (@LIMIT-1)

			@candidatesAnalysis.append([candidate, averageAnnotationScore, candidate.timetaken, candidate.progress, candidate.othernotes])			
		end

		#session[:user_id] = bestCandidate.id 	
		#redirect_to("/jobs/view_annotation/1")
	end	

	def post_update
		if currentUser and params[:user] and params[:user][:name] and params[:user][:email]
			cur = currentUser 
			cur.name = params[:user][:name]
			cur.email = params[:user][:email]
			cur.is_initialized = true
			if cur.save
				redirect_to("/skills/annotate/#{cur.get_skills_progress}")
			else
				redirect_to("/users/update")
			end
		end
	end

	def survey
		@curUser = currentUser
	end

	def post_survey
		@curUser = currentUser
		@curUser.timetaken = params[:user][:timetaken]
		@curUser.othernotes = params[:user][:othernotes]
		@curUser.name = params[:user][:name]
		@curUser.email = params[:user][:email]
		@curUser.save
		redirect_to("/users/survey")
		#@curUser.name = 
	end
end
