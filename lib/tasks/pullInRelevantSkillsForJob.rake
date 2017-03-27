task :pullInRelevantSkillsForJob => :environment do
	annotated_job_descriptions = Rails.root + "../annotated_job_descriptions.json"
    count = -1
    couldntFind = []

	File.open(annotated_job_descriptions).readlines.each do |line|
		count += 1
		if count % 100 ==0 
			puts "Processing line"
			puts count
		end

		if count >= 9940 # The final two jobs have problems. Come back to this!
			next 
		end

   		annotated_job_description = JSON.parse(line)

		mongo_id = annotated_job_description["job_mongo_id"]   		
		description = annotated_job_description["description"]   		

		#puts mongo_id
		cur_job = Job.find_by_mongo_id(mongo_id)

		if !cur_job
			couldntFind.append(mongo_id)
			#puts description
			#debugger
			#crash_here_asdfasdf
		else
			cur_job.description = description
			cur_job.is_description_annotated = true 
			if !cur_job.save
				puts "Something went wrong in saving job :("
				crash_here_asdfasdf
			end
		end
	end

	puts "Couldn't find", couldntFind.length, "mongo ids... here they are", couldntFind

	puts "DONE pulling in relevant skills for job!"
end 