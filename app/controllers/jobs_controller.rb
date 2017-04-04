class JobsController < ApplicationController
	before_action :require_logged_in_user

	def annotate
		if !currentUser
			redirect_to("https://stella.ai/")
			return
		end

		@LIMIT = 40

		if currentUser.progress >= @LIMIT
			redirect_to("/users/survey")
			return 
		end

		if !params[:id] or params[:id].to_i != currentUser.progress
			redirect_to("/jobs/annotate/#{currentUser.progress}")
			return
		end

		@job_to_annotate = Job.find_by_id(params[:id])
		@sov_user = User.find_by_email("soverign@soverign.com")

		@sov_annotation = Annotation.find_by(user: @sov_user, job_id: @job_to_annotate.id)
		@sov_annotation.skills ||= ""
		@sov_annotation.optional_skills ||= ""

		@nextJobId = params[:id].to_i + 1
	end

	def view_annotation
		@job_to_annotate = Job.find_by_id(params[:id])

		@sov_annotation = Annotation.find_by(user: currentUser, job_id: @job_to_annotate.id)
		@sov_annotation.skills ||= ""
		@sov_annotation.optional_skills ||= ""

		@nextJobId = params[:id].to_i + 1

		render(:action => :annotate)
	end	

	def post_annotate
		@newAnnotation = Annotation.new
		@newAnnotation.user = currentUser
		@newAnnotation.valid_posting = params[:acceptCheckbox] == "1"
		@newAnnotation.skills = params[:skillsInput]
		@newAnnotation.optional_skills = params[:niceSkillsInput]
		@newAnnotation.min_tenure = params[:minTenure]
		@newAnnotation.max_tenure = params[:maxTenure]
		@newAnnotation.education_level = params[:requiredDegreeInput]
		@newAnnotation.degree_major = params[:requiredMajorInput]
		@newAnnotation.personality = params[:requiredPersonalityInput]
		@newAnnotation.work_area = params[:requiredAreaInput]
		@newAnnotation.work_type = params[:partTime]

		if @newAnnotation.save
			curUser = currentUser
			curUser.progress += 1
			curUser.save
		end

		redirect_to("/jobs/annotate/#{currentUser.progress}")
	end

end
