task :migrateDb => :environment do
	puts "Loading jobs dump from local directory..."
	

	jobs_dump_filename = Rails.root + "../stella_client_jobs_dump.jobs.json"

	File.open(jobs_dump_filename).readlines.each do |line|
   		job_info = JSON.parse(line)

   		# Housekeeping 
		mongo_id = job_info["_id"]
		job_id = job_info["job_id"]

		# Job information 
		job_title = job_info["title"]
		company_name = job_info["company_name"]
		description = job_info["description"]

		posting = Job.new 
		posting.title = job_title
		posting.company_name = company_name
		posting.description = description
		posting.job_id = job_id
		posting.save 

		sov_annotations = Annotation.new 
		sov_annotations.job = posting

		# Get soverign predictions for job 
		if job_info.key?("RequiredSkills")
			req_skills = job_info["RequiredSkills"]["RequiredSkill"]

			if req_skills.is_a?(Array)
				req_skills = req_skills.join(", ")
			end		

			sov_annotations.skills = req_skills	
		end
		if job_info.key?("OtherSkills")
			other_skills = job_info["OtherSkills"]["OtherSkill"]

			if other_skills.is_a?(Array)
				other_skills = other_skills.join(", ")
			end

			sov_annotations.optional_skills = other_skills
		end		

		if job_info.key?("MinimumYears")
			sov_annotations.min_tenure = job_info["MinimumYears"]
		end

		if job_info.key?("MaximumYears")
			sov_annotations.max_tenure = job_info["MaximumYears"]
		end

		if job_info.key?("Education") and job_info["Education"]["Degree"]
			min_education = job_info["Education"]["Degree"]
			if min_education.instance_of? Hash
				degree_type = min_education["DegreeType"]
				degree_name = min_education["DegreeName"]
			elsif min_education.length > 0 
				degree_type = []
				degree_name = []

				for ii in 0..min_education.length
					edu_entry = min_education[ii]


					if edu_entry
						degree_type.append(edu_entry["DegreeType"])
						degree_name.append(edu_entry["DegreeName"])
					end
				end

				degree_type = degree_type.join(", ")
				degree_name = degree_name.join(", ")
			end 

			sov_annotations.education_level = degree_type
			sov_annotations.degree_major = degree_name
		end		

		if job_info.key?("workType")
			sov_annotations.work_type = job_info["workType"]
		end

		if job_info.key?("category")
			sov_annotations.work_area = job_info["category"]
		end

		sov_annotations.save
	end

	puts "DONE migrating!"
end 

def convertArrayToString(arr)
	s = ""

	for elem in arr
		s += "" + elem.to_s
	end

	return s
end





