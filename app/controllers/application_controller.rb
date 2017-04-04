class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	# Returns the current logged-in user (if any).
	def currentUser
		# @current_user is stored as instance variable, so if currentUser 
		# is used multiple times a database search isn't done every time
		@current_user ||= User.find_by(id: session[:user_id])
	end
	
	def require_logged_in_user
		if !currentUser
			redirect_to("https://stella.ai/")
			return
		end
	end
end
