class SkillsController < ApplicationController
	def currentUser
		# @current_user is stored as instance variable, so if currentUser 
		# is used multiple times a database search isn't done every time
		@current_user ||= User.find_by(id: session[:user_id])
	end

	def new
		job_id = params[:job_id]
		annotated_job_description = params[:annotated_job_description]
		
		new_annotated_skill = Skill.new
		new_annotated_skill.job_id = job_id 
		new_annotated_skill.annotated_job_description = annotated_job_description
		new_annotated_skill.user = currentUser

		currentUser.skills_progress += 1

		if new_annotated_skill.save and currentUser.save 
			render json: { status: 'success', next_id: currentUser.skills_progress }
		else
			render json: { errors: "Error in saving the annotation. Please try again." }, status: 422
		end

		
	end
end
