class Skillset < ActiveRecord::Base
	belongs_to :job
	belongs_to :user

	def Skillset.compute_list_similarity(list1, list2)
		if list1.length == 0 && list2.length == 0
			return 1.0
		elsif list1.length == 0 || list2.length == 0
			return 0.0
		end

		s1 = Set.new list1
		s2 = Set.new list2
		
		# compute intersection over union
		return (s1 & s2).length.to_f / (s1 | s2).length.to_f
	end

	def Skillset.extract_skills(annotated_description)
		fragment = Nokogiri::HTML.fragment(annotated_description)

		req_skill_spans = fragment.search("span.required_skill")
		opt_skill_spans = fragment.search("span.optional_skill")

		all_skills = []

		req_skill_spans.each do |span|
			all_skills.append("_______REQUIRED_______" + span.text)
		end

		opt_skill_spans.each do |span|
			all_skills.append("_______OPTIONAL_______" + span.text)
		end

		return all_skills
	end

	def Skillset.compute_similarity(annotated_description_gold, annotated_description_user)
		# First extract list of all annotated skills 
		skills_gold = Skillset.extract_skills(annotated_description_gold.annotated_job_description)
		skills_user = Skillset.extract_skills(annotated_description_user.annotated_job_description)

		return Skillset.compute_list_similarity(skills_gold, skills_user)
	end
end
