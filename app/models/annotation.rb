class Annotation < ActiveRecord::Base
	belongs_to :job
	belongs_to :user

	def Annotation.compute_string_similarity(commaSep1, commaSep2)
		commaSep1 ||= ""
		commaSep2 ||= ""

		if commaSep1.length == 0 && commaSep2.length == 0
			return 1.0
		elsif commaSep1.length == 0 || commaSep2.length == 0
			return 0.0
		end

		list1 = commaSep1.downcase.split(",")
		list2 = commaSep2.downcase.split(",")
		s1 = Set.new list1
		s2 = Set.new list2
		
		# compute intersection over union
		return (s1 & s2).length.to_f / (s1 | s2).length.to_f
	end

	def Annotation.compute_equality_similarity(bin1, bin2)
		return (bin1 == bin2) ? 1.0 : 0.0
	end

	def Annotation.compute_similarity(annotation1, annotation2)
		sim = 0.0 
		# Getting "easy" attributes gets 1 point each  
		# Then, compare annotations. Compute overlap 
		sim += Annotation.compute_equality_similarity(annotation1.valid_posting, annotation2.valid_posting)
		sim += Annotation.compute_equality_similarity(annotation1.min_tenure, annotation2.min_tenure)
		sim += Annotation.compute_equality_similarity(annotation1.max_tenure, annotation2.max_tenure)
		sim += Annotation.compute_equality_similarity(annotation1.work_type, annotation2.work_type)
		
		
		sim += Annotation.compute_string_similarity(annotation1.education_level, annotation2.education_level)
		sim += Annotation.compute_string_similarity(annotation1.degree_major, annotation2.degree_major)
		sim += Annotation.compute_string_similarity(annotation1.personality, annotation2.personality)
		sim += Annotation.compute_string_similarity(annotation1.work_area, annotation2.work_area)

		# These are toughest to compare / get correct 
		sim += Annotation.compute_string_similarity(annotation1.skills, annotation2.skills)
		sim += Annotation.compute_string_similarity(annotation1.optional_skills, annotation2.optional_skills)

		return sim / 10.0
	end

end
