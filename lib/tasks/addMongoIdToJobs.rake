task :addMongoIdToJobs => :environment do

	jobs_dump_filename = Rails.root + "../stella_client_jobs_dump_Feb24.json"
    count = 0

	File.open(jobs_dump_filename).readlines.each do |line|
		count += 1
		if count % 100 == 0 
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

		found_job_posting = Job.find_by(title: job_title, company_name: company_name, description: description)

		if !found_job_posting
			puts "Something went wrong fetching #{job_title} for #{company_name}"
			return 
		end

		found_job_posting.mongo_id = mongo_id
		found_job_posting.save
	end

	puts "DONE adding mongo db id!"
end 

def convertArrayToString(arr)
	s = ""

	for elem in arr
		s += "" + elem.to_s
	end

	return s
end





