class SkillsetsController < ApplicationController
	before_action :require_logged_in_user

	def annotate_skills
		@currentJobID = params[:id]
		@nextJobID = @currentJobID.to_i + 1
		@job_to_annotate = Job.find_by_id(@currentJobID)

		if !@job_to_annotate or !@job_to_annotate.is_description_annotated or currentUser.get_skills_progress > @currentJobID.to_i
			nextGuy = params[:id].to_i+1
			redirect_to("/skills/annotate/#{nextGuy.to_s}")
		end	
	end

	def save
		job_id = params[:job_id]
		annotated_job_description = params[:annotated_job_description]
		
		new_annotated_skill = Skillset.find_by(job_id: job_id, user: currentUser)
		if !new_annotated_skill
			new_annotated_skill = Skillset.new
		end
		new_annotated_skill.job_id = job_id 
		new_annotated_skill.annotated_job_description = annotated_job_description
		new_annotated_skill.user = currentUser
		new_annotated_skill.is_gold = currentUser.is_gold_annotator 

		if new_annotated_skill.save 
			# Also check to see if an admin has annotated the skill 
			redirect_url = "/skills/annotate/#{currentUser.get_skills_progress}"
			gold_annotation = Skillset.find_by(job_id: job_id, is_gold: true)
			if gold_annotation
				redirect_url = "/skills/compare_with_gold/#{job_id}"

				# TODO compute new accuracy for 
				current_accuracy = Skillset.compute_similarity(gold_annotation, new_annotated_skill)
				currentUser.update_skills_accuracy(current_accuracy)
				currentUser.save 
			end

			render json: { status: 'success', redirect_url:  redirect_url}
		else
			render json: { errors: "Error in saving the annotation. Please try again." }, status: 422
		end
	end

	def compare_with_gold
		job_id = params[:id]
		@gold_annotation = Skillset.find_by(job_id: job_id, is_gold: true)
		@user_annotation = Skillset.find_by(job_id: job_id, user: currentUser)

		@accuracy = Skillset.compute_similarity(@gold_annotation, @user_annotation) * 100
		@overallAccuracy = currentUser.skills_accuracy * 100

		@job_to_annotate = Job.find_by_id(job_id)
		@nextSkillsAnnotationLink = "/skills/annotate/#{currentUser.get_skills_progress}"
	end

	def leaderboard 
		# Only show users that have actually started the annotations
		@users = User.where("skills_accuracy > ?", 0.0) 
		@users = @users.where(is_gold_annotator: false)
	end
end








