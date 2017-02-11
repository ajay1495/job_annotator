task :generateAdditionalUsers => :environment do
	# Goes through and 
	for ii in 0..50
		newUser = User.new
		newUser.name = ""
		newUser.email = "temp#{ii+User.all.length}@temp.com"
		newUser.is_initialized = false
		newUser.digest = User.digest("#{ii+User.all.length}")
		if newUser.save 
			puts "http://j13.stella.ai:8080/login?&v=" + newUser.digest
		else
			puts "Something went wrong"
			return
		end
	end
end 