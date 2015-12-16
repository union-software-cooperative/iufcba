class Union < Supergroup

	has_many :people
	has_many :recs
	
	def post_title
		"Post your union pictures and status updates here"
	end
end
