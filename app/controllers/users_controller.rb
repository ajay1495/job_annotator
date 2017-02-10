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
	def login(user)
	  	session[:user_id] = user.id
	end

	def logout
		session.delete(:user_id)
		redirect_to("https://stella.ai/")
	end

	def invite
		if !params[:v] or !User.find_by_digest(params[:v])
			redirect_to("https://stella.ai/")
		else 
			@userToLogin = User.find_by_digest(params[:v])			
			login(@userToLogin)

			if !@userToLogin.is_initialized 
				redirect_to("/users/update")
			else
				redirect_to("/jobs/annotate/#{@userToLogin.progress}")
			end
		end
	end

	def post_update
		if currentUser and params[:user] and params[:user][:name] and params[:user][:email]
			cur = currentUser 
			cur.name = params[:user][:name]
			cur.email = params[:user][:email]
			cur.is_initialized = true
			if cur.save
				redirect_to("/jobs/annotate/#{cur.progress}")
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
