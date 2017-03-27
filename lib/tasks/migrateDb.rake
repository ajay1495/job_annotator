task :migrateDb => :environment do
	puts "Loading jobs dump from local directory..."
	
	sovUser = User.find_by_email("Soverign@Soverign.com")

	if !sovUser
		sovUser = User.new
		sovUser.name = "Soverign"
		sovUser.email = "Soverign@Soverign.com"
		sovUser.is_initialized = true
		sovUser.digest = ""
		sovUser.save 		
	end

	jobs_dump_filename = Rails.root + "../stella_client_jobs_dump_Feb24.json"
        count = 0
	File.open(jobs_dump_filename).readlines.each do |line|
		count += 1
		if count % 100 ==0 
			puts "Processing line"
			puts count
		end
   		job_info = JSON.parse(line)

   		# Housekeeping 
		mongo_id = job_info["_id"]["$oid"]
		job_id = job_info["job_id"]

		# Job information 
		job_title = job_info["title"]
		company_name = job_info["company_name"]
		description = job_info["description"]

		posting = Job.where(title: job_title, company_name: company_name)

		if posting.length > 1
			puts "Found #{posting.length} job postings with same job title, company title... deleting them and just creating one."
			posting.delete_all
			# 
		elsif posting.length == 1
			posting = posting[0]

			if posting.mongo_id != mongo_id
				posting.mongo_id = mongo_id
				posting.save 
			end

			next
		end

		posting = Job.new 
		posting.title = job_title
		posting.company_name = company_name
		posting.description = description
		posting.job_id = job_id
		posting.mongo_id = mongo_id

		# puts "New posting, processing it!"

		posting.save 

		sov_annotations = Annotation.new 
		sov_annotations.job = posting
		sov_annotations.user = sovUser

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

		if !sov_annotations.save
			print "Something bad happened."
		end
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





